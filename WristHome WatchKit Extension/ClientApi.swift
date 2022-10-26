//
//  ClientApi.swift
//  WristHome WatchKit Extension
//
//  Created by Tomas on 31.07.2022.
//

import Foundation

let LOADING_TEXT = "Loading"
let LOADING_ERROR = "Request failed"
let LOADING_INTERNAL_ERROR = "Internal error"

struct JsonResult: Decodable {
    let results: HomeState
    let success: Bool
}

class ClientApi: ObservableObject {
    var task: Timer?
    @Published var error: String? = nil
    @Published var loading: Bool = true;
    @Published var loadingText: String? = nil;
    @Published var gate: Bool = false;
    @Published var gateTime: String = "n/a";
    @Published var garage: Bool = false;
    @Published var garageTime: String = "n/a";
    @Published var garageTemp: Float = 0;
    @Published var bmsCurrent: Float = 0;
    @Published var bmsBatt: Int = 0;
    @Published var bmsBattState: String = "battery.0";
    @Published var inverter: InverterStruct? = nil
    @Published var bms: BmsStruct? = nil
    @Published var waterheater: WaterHeaterStruct? = nil
    @Published var floorheater: FloorHeaterStruct? = nil
    @Published var elheater: FloorHeaterStruct? = nil
    @Published var temperatures: TemperaturesStruct? = nil
    @Published var pool: PoolStruct? = nil
    @Published var poolHeating: PoolComponent? = nil
    @Published var poolLight: PoolComponent? = nil
    @Published var poolMotor: PoolComponent? = nil
    
    init() {
        self.task = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(readState), userInfo: nil, repeats: true)
        self.readState()
    }

    func setLoading(v: Bool){
        DispatchQueue.main.async {
            self.loading = v
        }
    }

    func setError(err: Error?) {
        DispatchQueue.main.async {
            if let error = err {
                self.error = error.localizedDescription
            } else {
                self.error = nil
            }
        }
    }

    func decodeState(results: HomeState){
        self.gate = results.gate.status.compare("1") == .orderedSame
        self.gateTime = results.gate.time
        self.garage = results.garage.status.compare("1") == .orderedSame
        self.garageTime = results.garage.time
        self.garageTemp = results.garageTemp
        self.bmsCurrent = Float(results.bms.current) ?? 0
        self.bmsBatt = Int(results.bms.bms_capacity) ?? 0
        self.inverter = results.inverter
        self.bms = results.bms
        self.waterheater = results.waterheater
        self.floorheater = results.floorheater
        self.elheater = results.elheater
        self.pool = results.pool
        self.poolLight = results.poolLight
        self.poolMotor = results.poolMotor
        self.poolHeating = results.poolHeating
        
        if self.bmsBatt > 75 {
            self.bmsBattState = "battery.100";
        } else if self.bmsBatt > 50 {
            self.bmsBattState = "battery.75";
        } else if self.bmsBatt > 25  {
            self.bmsBattState = "battery.50";
        } else if self.bmsBatt > 10 {
            self.bmsBattState = "battery.25";
        } else{
            self.bmsBattState = "battery.0";
        }
        
        self.temperatures = TemperaturesStruct(
            office: results.upstairsTemp1,
            kitchen: results.floorheater.room_temp,
            bedroom: results.upstairsTemp2,
            livingroom: results.elheater.room_temp,
            heater: results.heaterTemp
        )
    }
    
    @objc func readState(){
        httpPost(path: "/json.php?api=read") { (result, error) in
            self.setLoading(v: false)
            if result != nil {
                do {
                    let decoded = try JSONDecoder().decode(JsonResult.self, from: result!)
                    if decoded.success {
                        let results = decoded.results
                        DispatchQueue.main.async {
                            self.decodeState(results: results)
                        }
                    }
                    self.setError(err: nil)
                } catch{
                    print("failed to decoded json data", error);
                    self.setError(err: error)
                }
            }
        }
    }
    
    func sensorAction(sensor: String){
        self.setLoading(v: true)
        httpPost(path: "/json.php?api=update&sensor=" + sensor) { (result, error) in
            DispatchQueue.main.async {
                self.setLoading(v: false)
                self.setError(err: error)
                
                /*if let result = result {
                    print("success: \(result)")
                } else if let error = error {
                    print("error: \(error.localizedDescription)")
                    self.error = error.localizedDescription
                }*/
            }
        }
    }

    func httpPost(path: String,  completion: @escaping (Data?, Error?) -> Void) {
        if let serverAddr = ProcessInfo.processInfo.environment["X_SERVER_ADDR"] {
            let ts = String(NSDate().timeIntervalSince1970 * 1000)
            let url = URL(string: serverAddr + path + "&_dc=" + ts)!
            let urlSession = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            if let token = ProcessInfo.processInfo.environment["X_TOKEN"] {
                request.addValue(token, forHTTPHeaderField: "X-Token")
            }

            
            let task = urlSession.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
                guard error == nil else {
                    completion(nil, error)
                    return
                }

                guard let data = data else {
                    completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                    return
                }

                completion(data, nil)
            })
            
            task.resume()
        }
    }
}
