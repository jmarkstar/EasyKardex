package com.jmarkstar.easykardex.data.models

import com.squareup.moshi.Json

data class User(@Json(name = "idu") val userId: Long,
           @Json(name = "idr") var roleId: UserRole,
           @Json(name = "u") var username: String,
           @Json(name = "f") var fullname: String)