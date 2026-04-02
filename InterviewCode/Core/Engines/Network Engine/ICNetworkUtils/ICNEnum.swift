//
//  ICNEnum.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 15/03/26.
//

import Foundation

enum ICNetReqType: String {
    case get = "GET" //To fetch the data from server through an API
    case post = "POST" //To create entry inside the database through API
    case put = "PUT" //To update or replace existing entry in the database through API
    case patch = "PATCH" //To update or modify part of an existing entry in the database throguh API
    case delete = "DELETE" //To delete entry from the database through the API
}
