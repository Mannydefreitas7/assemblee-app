//
//  SetupViewModel.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import Foundation
import Combine
import CongregationServiceKit
import SwiftUI
import MapKit
import Firebase
import AuthenticationServices

enum PageType {
    case welcome, user, language, congregation, done
}

@MainActor
final class SetupViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    private var congregationKit = CongregationServiceKit()
    private var cloudkitHelper = CloudKitHelper()
    private var randomCodeGenerator = RandomPinGenerator.instance
    @Published var authenticationService = AuthenticationService()
    private var congregationRepository = CongregationRepository()
    private var publisherRepository = PublisherRepository()
    @Published var languages: [WOLLanguage] = [WOLLanguage]()
    
    @Published var page: PageType = .welcome
    @Published var newUser: ABUser = ABUser()
    @Published var congregation: ABCongregation = ABCongregation()
    @Published var confirmEmail: String = ""
    @Published var filteredLanguages: [WOLLanguage] = [WOLLanguage]()
    @Published var language: WOLLanguage?
    @Published var queryLanguage: String = ""
    @Published var queryLocation: String = ""
    @Published var isSearching: Bool = true
    @Published var isLoading: Bool = false
  
    
    // MARK: Map related values
    @Published var locationManager = LocationManager()
    @Published var markers : [MKMapItem] = [MKMapItem]()
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.201470, longitude: -74.210790), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    @Published var delta: Double = 0.7
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var places: [PointOfInterest] = [PointOfInterest]()
    @Published var congregations: [GeoLocationList] = [GeoLocationList]()
    @Published var locations: [MKLocalSearchCompletion] = [MKLocalSearchCompletion]()
    
    // Sign In With Apple
    @Published var authResult: AuthDataResult?
    @Published var errorMessage: String?
    
    @Published var logManager = LogManager()
    
    init() {
    
        Task {
           await self.fetchLanguages()
        }
        
        
        
        $queryLanguage
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { query in
                if !query.isEmpty && query.count > 3 {
                    
                    return self.languages.filter { _language in
                        if let title = _language.languageTitle, let verncular = _language.englishName {
                            return title.contains(query) || verncular.contains(query)
                        }
                        return false
                    }
                }
                return []
            }
            .assign(to: \.filteredLanguages, on: self)
            .store(in: &cancellables)
    
        
        $queryLocation
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { query in
                if !query.isEmpty && query.count > 4 {
                    Task {
                        await self.searchLocation(query)
                    }
                }
            }
            .store(in: &cancellables)
        
        $languages.map { languages in
            return languages.first { $0.locale == Locale.current.language.languageCode?.identifier ?? "en" }
            }
          .assign(to: \.language, on: self)
          .store(in: &cancellables)
        
        authenticationService.$errorMessage.compactMap { $0 }
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    
        
    }
    
    func next(appState: AssembleeAppState) {
        switch page {
        case .welcome:
            page = .user
        case .user:
            page = .language
        case .language:
            page = .congregation
        case .congregation:
            page = .done
        case .done:
            Task {
                await self.save(appState: appState)
            }
        }
    }
    
    func prev() {
        switch page {
        case .welcome:
            page = .welcome
        case .user:
            page = .welcome
        case .language:
            page = .user
        case .congregation:
            page = .language
        case .done:
            page = .congregation
        }
    }
    
    func searchLocation(_ query: String) async {
        isSearching = true
        do {
           let places = try await congregationKit.fetchPlaces(for: query)
            if let places, !places.isEmpty, let place = places.first, let geometry = place.geometry, let location = geometry.location, let lat = location.lat, let long = location.lng {
                let _location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                if let language = language, let symbol = language.mepsSymbol {
                    await fetchCongregations(for: _location, in: symbol)
                }
            }
        } catch {
            logManager.display(.error, title: "Error", message: error.localizedDescription)

        }
    }

    
    func fetchCongregations(for location: CLLocationCoordinate2D, in locale: String) async {
        do {
            self.congregations.removeAll()
            
            self.region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: self.delta, longitudeDelta: self.delta))
            let locations: [GeoLocationList] = try await self.congregationKit.getCongregations(for: location, in: locale)
        
            congregations = locations
            isSearching = false
            let _ = locations.map { location in
                let place: PointOfInterest = PointOfInterest(name: location.properties?.orgName ?? "", latitude: location.location?.latitude ?? 0.0, longitude: location.location?.longitude ?? 0.0, congregation: location)
                return place
            }
        
        } catch {
            logManager.display(.error, title: "Error", message: error.localizedDescription)
        }
    }
    

    
    func requestCurrentLocation() async {
    
        if let language {
            self.locationManager.requestLocation()
            
                switch self.locationManager.checkStatus() {
                case .notDetermined, .denied, .restricted:
                    logManager.display(.error, title: "Error", message: "Location access not determined")
                    self.locationManager.requestLocation()
                case .authorizedAlways, .authorizedWhenInUse:
                    if let currentLocation = locationManager.manager.location, let symbol = language.mepsSymbol {
                        await self.fetchCongregations(for: currentLocation.coordinate, in: symbol)
                    }
                    default: print("Location NOT SET")
            }
        }
     }
    
    func selectCongregation(from congregationList: GeoLocationList) {
        self.congregation.language = language
        self.congregation.passcode = randomCodeGenerator.generate(for: .congregation)
        self.congregation.properties = congregationList.properties
    }
    
    func validate() -> Bool {
        
        switch page {
        case .welcome:
            return true
        case .user:
            if let email = newUser.email, let firstName = newUser.firstName, !firstName.isEmpty, let lastName = newUser.lastName, !lastName.isEmpty, !email.isEmpty && !confirmEmail.isEmpty && email == confirmEmail {
                return true
            }
        case .language:
            if let _ = language {
                return true
            }
        case .congregation:
            if let _ = congregation.language {
                return true
            }
        case .done:
            if let email = newUser.email, let _ = language, let _ = congregation.language, !email.isEmpty && !confirmEmail.isEmpty && email == confirmEmail {
                return true
            }
        }
        return false
    }
    
    func fetchLanguages() async {
        do {
            let languages = try await congregationKit.getLanguages()
            self.languages = languages ?? []
        } catch {
            logManager.display(.error, title: "Error", message: error.localizedDescription)
        }
    }
    
    func addCongregation() async {
        do {
            congregation.language = language
            congregation.id = UUID().uuidString
            self.newUser.congregationId = try await self.congregationRepository.add(congregation)
        } catch {
            logManager.display(.error, title: "Error", message: error.localizedDescription)
        }
    }
    
    func addPublisher() async {
        do {
            var publisher: ABPublisher = ABPublisher.newPublisher()
            publisher.userId = newUser.id
            publisher.email = newUser.email
            publisher.congregation = newUser.congregation
            publisher.firstName = newUser.firstName
            publisher.lastName = newUser.lastName
            publisher.code = randomCodeGenerator.generate(for: .publisher)
            
            try await publisherRepository.add(publisher)
        } catch {
            logManager.display(.error, title: "Error", message: error.localizedDescription)
        }
    }
//
    func save(appState: AssembleeAppState) async {
        do {
            self.isLoading = true
            
            let congregationData = try congregation.encodedData()
            let userData = try newUser.encodedData()
            
            UserDefaults.standard.set(congregationData, forKey: "congregation")
            UserDefaults.standard.set(userData, forKey: "user")
            
            if let provider = newUser.provider, provider == "apple.com", let user = authenticationService.user {
                await self.addCongregation()
                newUser.permissions = [ABPermission.admin.rawValue]
                await appState.createUserFrom(user, newUser: newUser)
                self.isLoading = false
                appState.showSetup = false
            } else {
                if let email = newUser.email {
                    try await authenticationService.sendSignEmailLink(email: email)
                }
            }
        } catch {
            logManager.display(.error, title: "Error", message: error.localizedDescription)
        }
    }
}


// Sign in with Apple
extension SetupViewModel {
    
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        authenticationService.handleSignInWithAppleRequest(request)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        authenticationService.handleSignInWithAppleCompletion(result) { user in
            if let user, let email = user.email {
                
                self.newUser.email = email
                self.confirmEmail = email
                self.newUser.provider = "apple.com"
                if self.validate() {
                    self.page = .language
                }
            }
        }
    }
    
}
