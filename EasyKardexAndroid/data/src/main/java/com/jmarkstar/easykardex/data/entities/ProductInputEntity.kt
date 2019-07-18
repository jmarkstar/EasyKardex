/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2019 Marco Antonio Estrella Cardenas
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Created by jmarkstar on 7/12/19 6:01 PM
 *
 */

package com.jmarkstar.easykardex.data.entities

import androidx.room.*
import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass
import org.threeten.bp.OffsetDateTime
import java.util.*
import kotlin.collections.ArrayList

/** ProductInputEntity will work as a Entity for store it on SQLite, for parsing the API response and for use it on the up level.
 *
 *  @creatorId Field does not have foreigh key because the users are not going to be stored.
* */


@Entity(tableName = "product_input",
    indices = [Index("id"), Index("idProduct"), Index("idProvider")],
    primaryKeys = ["id"],
    foreignKeys = [
        ForeignKey(entity = ProductEntity::class, parentColumns = ["id"], childColumns = ["idProduct"]),
        ForeignKey(entity = ProviderEntity::class, parentColumns = ["id"], childColumns = ["idProvider"])
    ])


@JsonClass(generateAdapter = true)
data class ProductInputEntity(var id: Long,

                              @Json(name = "idpd")
                              var idProduct: Long,

                              @Json(name = "idpv")
                              var idProvider: Long,

                              @Json(name = "pp")
                              var purchasePrice: Double,

                              @Json(name = "ed")
                              var expirationDate: Date,

                              @Json(name = "q")
                              var quantity: Int,

                              @Json(name = "cuid")
                              var creatorId: Long,

                              @Json(name = "cd")
                              var createAt: OffsetDateTime
) {

    @Ignore var product: ProductEntity? = null
    @Ignore var provider: ProviderEntity? = null
    @Ignore var outputs: ArrayList<ProductOutputEntity>? = null
}