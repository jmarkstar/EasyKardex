package com.jmarkstar.easykardex.data.models

import androidx.room.Entity
import androidx.room.Index
import com.squareup.moshi.Json

@Entity(tableName = "product_category",
    indices = [Index("id")],
    primaryKeys = ["id"],
    ignoredColumns = ["products"])
data class Category(val id: Long? = null,
               @Json(name = "n") var name: String) {

    var products: List<Product>? = null
}