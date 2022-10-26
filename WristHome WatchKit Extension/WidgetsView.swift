//
//  WidgetsView.swift
//  WristHome WatchKit Extension
//
//  Created by Tomas on 01.08.2022.
//

import SwiftUI

struct WidgetsView: View {
    @StateObject var api: ClientApi
    var foreverAnimation: Animation {
        Animation.linear(duration: 1).repeatForever(autoreverses: false)
    }
    @State private var poolHeatingIcoRotate = false
    @State private var poolMotorIcoRotate = false

    var body: some View {
       ScrollView {
            // devices
            NavigationLink(destination: ScrollView() {
                VStack() {
                    Text(self.api.gateTime).font(.footnote);
                    Button(action: {
                        self.api.sensorAction(sensor: "gate")
                    }) {
                        Image(systemName: self.api.gate ? "lock" : "lock.open")
                    };
                }
            }.navigationTitle(TEXT_GATE), label: {
                HStack {
                    Image(systemName: self.api.gate ? "lock.open" : "lock");
                    Text(TEXT_GATE);
                    Spacer();
                }
            })

            NavigationLink(destination: ScrollView() {
                VStack() {
                    Text(self.api.garageTime).font(.footnote);
                    Button(action: {
                        self.api.sensorAction(sensor: "garage")
                    }) {
                        Image(systemName: self.api.garage ? "lock" : "lock.open")
                    };
                }
            }.navigationTitle(TEXT_GARAGE), label: {
                HStack {
                    Image(systemName: self.api.garage ? "lock.open" : "lock");
                    Text(TEXT_GARAGE);
                    Spacer();
                    Text(String(self.api.garageTemp) + "°C").font(.footnote)
                }
            });

            NavigationLink(destination: ScrollView() {
                VStack() {
                    HStack {
                        Image(systemName: self.api.bmsCurrent > 0 ? "bolt" : self.api.bmsBattState);
                        Text("Batt")
                        Text(String(self.api.bmsBatt) + "%").font(.footnote);
                        Spacer()
                        Text(String(self.api.bmsCurrent) + "A").font(.footnote);
                    }
                    if let inverter = self.api.inverter {
                        HStack {
                            Image(systemName: "house")
                            Text("AC OUT");
                            Text(inverter.output_load + "%").font(.footnote)
                            Spacer();
                            Text(inverter.ac_out_power + "W").font(.footnote);
                        }
                        HStack {
                            Image(systemName: "sun.max.circle")
                            Text("PV power")
                            Spacer()
                            Text(inverter.pv_power + "W").font(.footnote)
                        }
                        HStack {
                            Image(systemName: "sun.max")
                            Text("PV1")
                            Text(inverter.pv1_voltage + "V").font(.footnote)
                            Spacer()
                            Text(inverter.pv1_current + "A").font(.footnote)
                        }
                        HStack {
                            Image(systemName: "sun.max")
                            Text("PV2")
                            Text(inverter.pv2_voltage + "V").font(.footnote)
                            Spacer()
                            Text(inverter.pv2_current + "A").font(.footnote)
                        }
                        HStack {
                            Image(systemName: "gearshape")
                            Text("Mode")
                            Text(inverter.mode).font(.footnote)
                            Spacer()
                            Text(inverter.output_priority).font(.footnote)
                        }
                        HStack {
                            Image(systemName: "thermometer.sun");
                            Text("Temp")
                            Spacer()
                            Text(inverter.inverter_temp + "°C")
                        }
                    }
                    Spacer();
                    
                    if let bms = self.api.bms {
                        HStack {
                            Text("T1: " + bms.temp1 + "°C").font(.footnote);
                            Spacer();
                            Text("T2: " + bms.temp2 + "°C").font(.footnote);
                        }
                        HStack {
                            Text("min: " + bms.cell_min).font(.footnote);
                            Spacer();
                            Text("max: " + bms.cell_max).font(.footnote);
                        }
                        Spacer();
                        
                        HStack {
                            Text("01: " + bms.cell_0).font(.footnote);
                            Spacer();
                            Text("02: " + bms.cell_1).font(.footnote);
                        }
                        HStack {
                            Text("03: " + bms.cell_2).font(.footnote);
                            Spacer();
                            Text("04: " + bms.cell_3).font(.footnote);
                        }
                        HStack {
                            Text("05: " + bms.cell_4).font(.footnote);
                            Spacer();
                            Text("06: " + bms.cell_5).font(.footnote);
                        }
                        HStack {
                            Text("07: " + bms.cell_6).font(.footnote);
                            Spacer();
                            Text("08: " + bms.cell_7).font(.footnote);
                        }
                        HStack {
                            Text("09: " + bms.cell_8).font(.footnote);
                            Spacer();
                            Text("10: " + bms.cell_9).font(.footnote);
                        }
                        HStack {
                            Text("11: " + bms.cell_10).font(.footnote);
                            Spacer();
                            Text("12: " + bms.cell_11).font(.footnote);
                        }
                        HStack {
                            Text("13: " + bms.cell_12).font(.footnote);
                            Spacer();
                            Text("14: " + bms.cell_13).font(.footnote);
                        }
                    }
                }
            }.navigationTitle(TEXT_FVE), label: {
                VStack {
                    if let inverter = self.api.inverter {
                        HStack {
                            VStack (alignment: .leading) {
                                Image(systemName: "house").font(.footnote);
                                Spacer();
                                Image(systemName: self.api.bmsCurrent > 0 ? "bolt" : self.api.bmsBattState).font(.footnote);
                            }
                            VStack (alignment: .leading)  {
                                Text(inverter.ac_out_power + "W").font(.footnote);
                                Text(String(self.api.bmsBatt) + "%").font(.footnote).frame(alignment: .trailing);
                            }
                            Spacer();
                            VStack (alignment: .trailing) {
                                Text(inverter.pv_power + "W").font(.footnote);
                                Text(String(self.api.bmsCurrent) + "A").font(.footnote);
                            }
                        }
                    }
                }
            });
            
            if let waterheater = self.api.waterheater {
                NavigationLink(destination: ScrollView() {
                    HStack {
                        Text("Teplota").font(.caption)
                        Spacer();
                        Text(waterheater.temp + "°C").font(.footnote);
                    }
                    
                    HStack {
                        Text("VT").font(.caption)
                        Spacer();
                        Text(waterheater.vt).font(.footnote);
                    }
                    
                    HStack {
                        Text("Alarm").font(.caption)
                        Spacer();
                        Text(waterheater.alarm).font(.footnote);
                    }
                    
                    HStack {
                        Text("Průměr").font(.caption);
                        Spacer();
                        Text((waterheater.avg_temp ?? "") + "°C").font(.footnote);
                    }
                    
                    Button(action: {
                        self.api.sensorAction(sensor: "waterheater")
                    }) {
                        Image(systemName: waterheater.power.compare("0") == .orderedSame ? "power" : "moon")
                    };
                }.navigationTitle(TEXT_WATERHEATER), label: {
                    HStack {
                        Image(systemName: waterheater.power.compare("0") == .orderedSame ? "moon" : "power");
                        Text(TEXT_WATERHEATER);
                        Spacer();
                        Text(String(waterheater.temp) + "°C").font(.footnote)
                    }
                });
            }
            
            if let floorheater = self.api.floorheater {
                NavigationLink(destination: ScrollView() {
                    HStack {
                        Text("Teplota").font(.caption)
                        Spacer();
                        Text(floorheater.heater_temp + "°C").font(.footnote);
                    }

                    HStack {
                        Text("Místnost").font(.caption);
                        Spacer();
                        Text(floorheater.room_temp + "°C").font(.footnote);
                    }
                    
                    Button(action: {
                        self.api.sensorAction(sensor: "floorheater")
                    }) {
                        Image(systemName: floorheater.power.compare("0") == .orderedSame ? "power" : "moon")
                    };
                }.navigationTitle(TEXT_FLOORHEATERL), label: {
                    HStack {
                        Image(systemName: floorheater.power.compare("0") == .orderedSame ? "moon" : "power");
                        Text(TEXT_FLOORHEATER);
                        Spacer();
                        Text(String(floorheater.heater_temp) + "°C").font(.footnote)
                    }
                });
            }
            
            if let elheater = self.api.elheater {
                NavigationLink(destination: ScrollView() {
                    HStack {
                        Text("Teplota").font(.caption)
                        Spacer();
                        Text(elheater.heater_temp + "°C").font(.footnote);
                    }

                    HStack {
                        Text("Místnost").font(.caption);
                        Spacer();
                        Text(elheater.room_temp + "°C").font(.footnote);
                    }
                    
                    Button(action: {
                        self.api.sensorAction(sensor: "elheater")
                    }) {
                        Image(systemName: elheater.power.compare("0") == .orderedSame ? "power" : "moon")
                    };
                }.navigationTitle(TEXT_ELHEATER), label: {
                    HStack {
                        Image(systemName: elheater.power.compare("0") == .orderedSame ? "moon" : "power");
                        Text("El.kotel");
                        Spacer();
                        Text(String(elheater.heater_temp) + "°C").font(.footnote)
                    }
                });
            }

            if let pool = self.api.pool {
                NavigationLink(destination: ScrollView() {
                    HStack {
                        Text("Teplota").font(.caption);
                        Spacer();
                        Text(pool.temp + "°C").font(.footnote);
                    }

                    HStack {
                        Text("Solár").font(.caption);
                        Spacer();
                        Text(pool.solar_temp + "°C").font(.footnote);
                    }
                    
                    if let poolMotor = self.api.poolMotor {
                        Button(action: {
                            self.api.sensorAction(sensor: "poolmotor")
                        }) {
                            Image(systemName: poolMotor.running ? "moon" : "gearshape.fill");
                            Text("Filtrace");
                        };
                    }
                    if let poolLight = self.api.poolLight {
                        Button(action: {
                            self.api.sensorAction(sensor: "poollight")
                        }) {
                            Image(systemName: poolLight.running ? "lightbulb" : "lightbulb.fill");
                            Text("Osvětlení");
                        };
                    }
                    
                    if let poolHeating = self.api.poolHeating {
                        Button(action: {
                            self.api.sensorAction(sensor: "poolheating")
                        }) {
                            Image(systemName: poolHeating.running ? "fanblades" : "fanblades.fill");
                            Text("Tepelné čerpadlo");
                        };
                    }
                }.navigationTitle(TEXT_POOL), label: {
                    VStack {
                        HStack {
                            if let poolMotor = self.api.poolMotor {
                                if poolMotor.running {
                                    Image(systemName: "gearshape.fill")
                                        .rotationEffect(Angle(degrees: self.poolMotorIcoRotate ? 360 : 0))
                                        .animation(foreverAnimation, value: self.poolMotorIcoRotate)
                                        .transition(.opacity)
                                        .onAppear(perform: {
                                            self.poolMotorIcoRotate = true
                                        })
                                } else {
                                    Image(systemName: "moon")
                                }
                            }
                            
                            Text(TEXT_POOL);
                            if let poolLight = self.api.poolLight {
                                if poolLight.running {
                                    Image(systemName: poolLight.running ? "lightbulb.fill" : "lightbulb")
                                        .font(.footnote);
                                }
                            }
                            if let poolHeating = self.api.poolHeating {
                                if poolHeating.running {
                                    Image(systemName: "gearshape.fill")
                                        .font(.footnote)
                                        .rotationEffect(Angle(degrees: self.poolHeatingIcoRotate ? 360 : 0))
                                        .animation(foreverAnimation, value: self.poolHeatingIcoRotate)
                                        .transition(.opacity)
                                        .onAppear(perform: {
                                            self.poolHeatingIcoRotate = true
                                        })
                                }
                            }
                            Spacer();
                            Text(String(pool.temp) + "°C").font(.footnote)
                        }
                    }
                });
            }
            
            if let temperatures = self.api.temperatures {
                Button (action: {}) {
                    HStack {
                        Image(systemName: "thermometer.sun");
                        Text("Pracovna");
                        Spacer();
                        Text(temperatures.office! + "°C").font(.footnote);
                    }
                }
                Button (action: {}) {
                    HStack {
                        Image(systemName: "thermometer.sun");
                        Text("Ložnice");
                        Spacer();
                        Text(temperatures.bedroom! + "°C").font(.footnote);
                    }
                }
                Button (action: {}) {
                    HStack {
                        Image(systemName: "thermometer.sun");
                        Text("Kuchyn");
                        Spacer();
                        Text(temperatures.kitchen! + "°C").font(.footnote);
                    }
                }
                Button (action: {}) {
                    HStack {
                        Image(systemName: "thermometer.sun");
                        Text("Obývák");
                        Spacer();
                        Text(temperatures.livingroom! + "°C").font(.footnote);
                    }
                }
                Button (action: {}) {
                    HStack {
                        Image(systemName: "thermometer.sun");
                        Text("Kotel");
                        Spacer();
                        Text(String(temperatures.heater!) + "°C").font(.footnote);
                    }
                }
            }
       }
    }
}
