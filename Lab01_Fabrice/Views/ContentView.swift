import SwiftUI

struct ContentView: View {
    @State private var isSimpleMode: Bool = true {
        didSet {
            simpleModel.predictedPrice = nil
            multiModel.predictedPrice = nil
        }
    }
    @State private var simpleModel = HousePriceSimpleModel()
    @State private var multiModel = HousePriceMultiModels()

    let cities=Array(Set([
        "Seattle",
        "Carnation",
        "Issaquah",
        "Maple Valley",
        "Kent",
        "Redmond",
        "Clyde Hill",
        "Mercer Island",
        "Auburn",
        "Bellevue",
        "Duvall",
        "Renton",
        "Sammamish",
        "Woodinville",
        "Shoreline",
        "Burien",
        "Federal Way",
        "Normandy Park",
        "Vashon",
        "Yarrow Point",
        "Lake Forest Park",
        "Des Moines",
        "SeaTac",
        "Newcastle",
        "Snoqualmie",
        "Fall City",
        "Medina",
        "North Bend",
        "Ravensdale",
        "Tukwila",
        "Covington",
        "Kenmore"
    ])).sorted()


    var isPredictEnabled: Bool {
        if isSimpleMode {
            return simpleModel.bedrooms > 0
        } else {
            return multiModel.bedrooms > 0 && multiModel.bathrooms > 0
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            VStack {
                HStack {
                    VStack(spacing:10){
                        Text("House Price Prediction")
                            .font(.title.bold())
                            .fontWeight(.bold)
                        Image(systemName: "australiandollarsign.bank.building")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.red)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.3))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Picker("Model", selection: $isSimpleMode) {
                    Text("Simple").tag(true)
                    Text("Multi").tag(false)
                }
                .pickerStyle(.segmented)
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Form {
                    Section(header: Text("Input")) {
                        if isSimpleMode {
                            Stepper("Bedrooms: \(simpleModel.bedrooms, specifier: "%.0f")", value: $simpleModel.bedrooms, in: 0...10)
                            //Resultat instantané
                                .onChange(of: simpleModel.bedrooms) {
                                                                simpleModel.predictPrice()
                                                            }
                                .padding(.bottom, 20)
                        } else {
                            Stepper("Bedrooms: \(multiModel.bedrooms, specifier: "%.0f")", value: $multiModel.bedrooms, in: 0...10)
                                .onChange(of: multiModel.bedrooms) {
                                                                multiModel.predictPrice()
                                                            }

                            Stepper("Bathrooms: \(multiModel.bathrooms, specifier: "%.2f")", value: $multiModel.bathrooms, in: 0...5, step: 0.25)
                                .onChange(of: multiModel.bathrooms) {
                                                                multiModel.predictPrice()
                                                            }

                            Picker("City", selection: $multiModel.city) {
                                ForEach(cities, id: \.self) { city in
                                    Text(city)
                                }
                            }
                            .onChange(of: multiModel.city) {
                                                            multiModel.predictPrice()
                                                        }
                        }

                        Button("Predict Price") {
                            if isSimpleMode {
                                simpleModel.predictPrice()
                            } else {
                                multiModel.predictPrice()
                            }
                        }
                        .disabled(!isPredictEnabled)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 10)
                    }

                    Section(header: Text("Output")) {
                        if !isPredictEnabled {
                            Text("Veuillez remplir les champs.")
                        }
                        else
                        {
                            if isSimpleMode {
                                Text("Prix estimé : $\(simpleModel.predictedPrice ?? 0, specifier: "%.2f")")
                            } else {
                                Text("Prix estimé : $\(multiModel.predictedPrice ?? 0, specifier: "%.2f")")
                            }
                        }
                    }
                    .foregroundStyle(.green)
                    .font(.headline.weight(.bold))
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

