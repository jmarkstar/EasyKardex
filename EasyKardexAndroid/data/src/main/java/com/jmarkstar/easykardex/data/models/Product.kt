package com.jmarkstar.easykardex.data.models

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import com.squareup.moshi.Json

@Entity(tableName = "product",
    indices = [Index("id")],
    primaryKeys = ["id"],
    foreignKeys = [
        ForeignKey(entity = Brand::class, parentColumns = ["id"], childColumns = ["brandId"]),
        ForeignKey(entity = Category::class, parentColumns = ["id"], childColumns = ["categoryId"]),
        ForeignKey(entity = Unit::class, parentColumns = ["id"], childColumns = ["unitId"])
    ],
    ignoredColumns = ["brand", "category", "unit"])
data class Product(@Json(name = "idp") val id: Long? = null,
              @Json(name = "idb") var brandId: Long,
              @Json(name = "idc") var categoryId: Long,
              @Json(name = "idu") var unitId: Long,
              @Json(name = "n")   var name: String,
              @Json(name = "t")   var thumb: String,
              @Json(name = "i")   var image: String,
              @Json(name = "d")   var description: String) {

    var brand: Brand? = null
    var category: Category? = null
    var unit: Unit? = null
}