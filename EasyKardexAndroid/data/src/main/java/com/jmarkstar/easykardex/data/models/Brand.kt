package com.jmarkstar.easykardex.data.models

import androidx.room.Entity
import androidx.room.Index
import com.squareup.moshi.Json


@Entity(tableName = "product_brand",
    indices = [Index("id")],
    primaryKeys = ["id"],
    ignoredColumns = ["products"])


data class Brand(val id: Long? = null,
            @Json(name = "n") var name: String) {

    var products: ArrayList<Product>? = null
}