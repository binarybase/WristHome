//
//  ApiDefinitions.swift
//  WristHome WatchKit Extension
//
//  Created by Tomas on 01.08.2022.
//

import Foundation

struct PoolStruct: Decodable {
    let heating: String
    let heating_current: String
    let light: String
    let power: String
    let solar_temp: String
    let temp: String
}

struct PoolComponent: Decodable {
    let running: Bool
    let running_time: String?
}

struct TemperaturesStruct {
    let office: String?
    let kitchen: String?
    let bedroom: String?
    let livingroom: String?
    let heater: Float?
}

struct InverterStruct: Decodable {
    let ac_out_power: String
    let avg_pvpower: Float
    let bus_voltage: Float
    let grid_voltage: String
    let inverter_temp: String
    let mode: String
    let output_load: String
    let output_priority: String
    let pv1_current: String
    let pv1_voltage: String
    let pv2_current: String
    let pv2_voltage: String
    let pv_active: String
    let pv_power: String
}

struct BmsStruct: Decodable {
    let bms_capacity: String
    let current: String
    let voltage: String
    let cell_0: String
    let cell_1: String
    let cell_2: String
    let cell_3: String
    let cell_4: String
    let cell_5: String
    let cell_6: String
    let cell_7: String
    let cell_8: String
    let cell_9: String
    let cell_10: String
    let cell_11: String
    let cell_12: String
    let cell_13: String
    let cell_diff: String
    let cell_min: String
    let cell_max: String
    let temp1: String
    let temp2: String
}

struct WaterHeaterStruct: Decodable {
    let alarm: String
    let avg_temp: String?
    let power: String
    let temp: String
    let vt: String
}

struct FloorHeaterStruct: Decodable {
    let heater_temp: String
    let power: String
    let room_temp: String
}

struct HomeState: Decodable {
    let gate: GateStruct
    let garage: GateStruct
    let garageTemp: Float
    let bms: BmsStruct
    let inverter: InverterStruct
    let waterheater: WaterHeaterStruct
    let floorheater: FloorHeaterStruct
    let elheater: FloorHeaterStruct
    let upstairsTemp1: String
    let upstairsTemp2: String
    let heaterTemp: Float
    let pool: PoolStruct
    let poolHeating: PoolComponent
    let poolLight: PoolComponent
    let poolMotor: PoolComponent
    
    enum CodingKeys: String, CodingKey {
        case
            gate, garage, garageTemp, heaterTemp,
            bms, inverter, waterheater, floorheater, elheater,
            upstairsTemp1, upstairsTemp2,
            pool, poolHeating, poolLight, poolMotor
    }

    struct GateStruct: Decodable {
        let time: String
        let status: String
    }
}
