package com.jmarkstar.easykardex.data.models

import androidx.room.Entity
import androidx.room.Index
import com.squareup.moshi.Json


@Entity(tableName = "provider",
    indices = [Index("id")],
    primaryKeys = ["id"],
    ignoredColumns = ["inputs"])


data class Provider(var id: Long,
                    @Json(name = "cpn") var companyName: String,
                    @Json(name = "cn") var contactName: String,
                    @Json(name = "cp") var contactPhoneNumber: String) {

    var inputs: ArrayList<ProductInput>? = null
}