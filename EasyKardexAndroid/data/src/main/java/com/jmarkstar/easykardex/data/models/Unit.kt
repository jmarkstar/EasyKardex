package com.jmarkstar.easykardex.data.models

import androidx.room.Entity
import androidx.room.Index
import com.squareup.moshi.Json

@Entity(tableName = "product_unit",
    indices = [Index("id")],
    primaryKeys = ["id"],
    ignoredColumns = ["products"])
data class Unit(val id: Long? = null,
           @Json(name = "n") var name: String) {

    var products: List<Product>? = null
}