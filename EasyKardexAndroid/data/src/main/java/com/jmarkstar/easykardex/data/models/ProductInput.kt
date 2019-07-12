package com.jmarkstar.easykardex.data.models

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import com.squareup.moshi.Json
import java.util.*
import kotlin.collections.ArrayList

/** ProductInput will work as a Entity for store it on SQLite, for parsing the API response and for use it on the up level.
 *
 *  @creatorId Field does not have foreigh key because the users are not going to be stored.
* */


@Entity(tableName = "product_input",
    indices = [Index("id")],
    primaryKeys = ["id"],
    foreignKeys = [
        ForeignKey(entity = Product::class, parentColumns = ["id"], childColumns = ["idProduct"]),
        ForeignKey(entity = Provider::class, parentColumns = ["id"], childColumns = ["idProvider"])
    ],
    ignoredColumns = ["product", "provider", "outputs"])


data class ProductInput(var id: Long,
                        @Json(name = "idpd")  var idProduct: Long,
                        @Json(name = "idpv")  var idProvider: Long,
                        @Json(name = "pp")  var purchasePrice: Double,
                        @Json(name = "ed")  var expirationDate: Date,
                        @Json(name = "q")  var quantity: Int,
                        @Json(name = "cuid")  var creatorId: Long,
                        @Json(name = "cd")  var createAt: Date) {

    var product: Product? = null
    var provider: Provider? = null
    var outputs: ArrayList<ProductOutput>? = null
}