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

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Ignore
import androidx.room.Index
import com.jmarkstar.easykardex.domain.models.Product
import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass
import org.threeten.bp.OffsetDateTime


@Entity(tableName = "product",
    indices = [Index("id"), Index("brandId"), Index("categoryId"), Index("unitId")],
    primaryKeys = ["id"],
    foreignKeys = [
        ForeignKey(entity = BrandEntity::class, parentColumns = ["id"], childColumns = ["brandId"]),
        ForeignKey(entity = CategoryEntity::class, parentColumns = ["id"], childColumns = ["categoryId"]),
        ForeignKey(entity = UnitEntity::class, parentColumns = ["id"], childColumns = ["unitId"])
    ])


@JsonClass(generateAdapter = true)
data class ProductEntity(@Json(name = "idp") val id: Long? = null,
                         @Json(name = "idb") var brandId: Long,
                         @Json(name = "idc") var categoryId: Long,
                         @Json(name = "idu") var unitId: Long,
                         @Json(name = "n")   var name: String,
                         @Json(name = "t")   var thumb: String,
                         @Json(name = "i")   var image: String,
                         @Json(name = "d")   var description: String,
                         @Json(name = "cd") var creationDate: OffsetDateTime? = null,
                         @Json(name = "lud") var lastUpdateDate: OffsetDateTime? = null,
                         @Json(name = "s") var status: EntityStatus = EntityStatus.ACTIVE) {

    @Ignore var brand: BrandEntity? = null
    @Ignore var category: CategoryEntity? = null
    @Ignore var unit: UnitEntity? = null
    @Ignore var inputs: ArrayList<ProductInputEntity>? = null
}

fun ProductEntity(domain: Product): ProductEntity = ProductEntity(domain.id,
                                                                domain.brandId,
                                                                domain.categoryId,
                                                                domain.unitId,
                                                                domain.name,
                                                                domain.thumb,
                                                                domain.image,
                                                                domain.description)

fun ProductEntity.mapToDomain(): Product = Product(id, brandId, categoryId, unitId, name, thumb, image, description)

fun List<ProductEntity>.mapToDomain(): List<Product> = map { it.mapToDomain() }