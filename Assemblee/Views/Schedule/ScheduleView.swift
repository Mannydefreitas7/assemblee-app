//
//  ScheduleView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import SwiftUI

struct ScheduleView: View {

        @ObservedObject var viewModel: ScheduleViewModel
        @State private var isPresented: Bool = false
        @State private var url: URL?
        @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
        @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?

        
        var body: some View {
            
            Group {
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading) {
                        chairman(for:0)
                        prayer(for:0)
                        treasures(color: treasuresColor, title: STRING_TREASURES)
                        apply(color: applyColor, title: STRING_APPLY)
                        life(color: lifeColor, title: STRING_LIFE)
                        secondary(title: STRING_SECONDARY)
                        prayer(for:1)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom)
                    Divider()
                }

            }
        
            .background(Color(.secondarySystemGroupedBackground))
            .navigationTitle(viewModel.week?.range ?? "")
            
        }
        // MARK: Chairman
        @ViewBuilder func chairman(for index: Int) -> some View {
            VStack(alignment: .leading) {
                if viewModel.chairmans.count > index {
                    SchedulePart(part:viewModel.chairmans[index])
                }
            }.padding(.vertical, 5)
        }
            // MARK: Prayer
        @ViewBuilder func prayer(for index: Int) -> some View {
            VStack(alignment: .leading) {
                if viewModel.prayers.count > index {
                    SchedulePart(part: viewModel.prayers[index])
                
                }
            }.padding(.vertical, 5)
        }
        // MARK: Treasures
        @ViewBuilder func treasures(color: String, title: String) -> some View {
            Group {
                SectionTitle(text: title, color: Color(color))
                    VStack(alignment: .leading) {
                        ForEach(viewModel.treasures) { part in
                            if let part = part {
                                SchedulePart(part: part)
                            }
                        }
                    }
                    .padding(.leading)
                    .padding(.bottom)
            }
        }
        // MARK: Apply
        @ViewBuilder func apply(color: String, title: String) -> some View {
            Group {
                SectionTitle(text: title, color: Color(color))
                    VStack(alignment: .leading) {
                        ForEach(viewModel.apply) {
                            SchedulePart(part: $0)
                        }
                    }
                    .padding(.leading)
                    .padding(.bottom)
            }
        }
        // MARK: Life
        @ViewBuilder func life(color: String, title: String) -> some View {
            Group {
                SectionTitle(text: title, color: Color(color))
                    VStack(alignment: .leading) {
                        ForEach(viewModel.life) {  SchedulePart(part: $0)
                        }
                    }
                    .padding(.leading)
                    .padding(.bottom)
            }
        }
        // MARK: Secondary
        @ViewBuilder func secondary(title: String) -> some View {
            if !viewModel.secondary.isEmpty {
                VStack {
                    SectionTitle(text: title, color: Color(.secondaryLabel))
                    
                        VStack(alignment: .leading) {
                            ForEach(viewModel.secondary) { SchedulePart(part: $0) }
                        }
                        .padding(.leading)
                        .padding(.bottom)
                }
                .padding()
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(10)
            }
        }
        
//        @ViewBuilder func downloadButton() -> some View {
//            Button(action: {
//                viewModel.generatePDF()
//            }, label: {
//                HStack {
//
//                    if !viewModel.isPDFLoading {
//                        Text("Download")
//                            .fontWeight(.semibold)
//
//                        Image(systemName: "arrow.down.doc.fill")
//                            .symbolRenderingMode(.hierarchical)
//                            .foregroundStyle(Color(primaryColor))
//                    } else {
//                        Text("Downloading...")
//                            .fontWeight(.semibold)
//
//                        ProgressView()
//                            .tint(Color.accentColor)
//                    }
//
//                }
//            }).disabled(viewModel.isPDFLoading)
//
//                .if(horizontalSizeClass == .regular) { button in
//                    button
//                        .popover(isPresented: $viewModel.showActivitySheet) {
//                            if let path = viewModel.pdfPath {
//                                ShareSheet(activityItems: [path])
//                            }
//
//                        }
//                }
//                .if(horizontalSizeClass == .compact) { button in
//                    button
//                        .bottomSheet(isPresented:  $viewModel.showActivitySheet) {
//                            if let path = viewModel.pdfPath {
//                                ShareSheet(activityItems: [path])
//                            }
//                        }
//                }
//        }
    }
