package com.jmarkstar.easykardex.data.models

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import com.squareup.moshi.Json
import java.util.*

/** ProductOutput will work as a Entity for store it on SQLite, for parsing the API response and for use it on the up level.
 *
 *  @creatorId Field does not have foreigh key because the users are not going to be stored.
 * */


@Entity(tableName = "product_output",
    indices = [Index("id")],
    primaryKeys = ["id"],
    foreignKeys = [
        ForeignKey(entity = ProductInput::class, parentColumns = ["id"], childColumns = ["idProductInput"])
    ],
    ignoredColumns = ["productInput"])


class ProductOutput(var id: Long,
                    @Json(name = "idpi") var idProductInput: Long,
                    @Json(name = "q") var quantity: Int,
                    @Json(name = "cuid") var creatorId: Long,
                    @Json(name = "cd")  var createAt: Date) {

    var productInput: ProductInput? = null
}