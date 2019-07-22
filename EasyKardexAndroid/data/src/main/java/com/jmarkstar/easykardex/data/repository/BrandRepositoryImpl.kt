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
 * Created by jmarkstar on 7/22/19 2:49 PM
 *
 */

package com.jmarkstar.easykardex.data.repository

import com.jmarkstar.easykardex.data.api.BrandService
import com.jmarkstar.easykardex.data.database.daos.BrandDao
import com.jmarkstar.easykardex.data.entities.BrandEntity
import com.jmarkstar.easykardex.data.entities.mapToDomain
import com.jmarkstar.easykardex.domain.datasources.BrandRepository
import com.jmarkstar.easykardex.domain.models.FailureReason
import com.jmarkstar.easykardex.domain.models.ProductProperty
import com.jmarkstar.easykardex.domain.models.Result

internal class BrandRepositoryImpl(private val brandDao: BrandDao, private val brandService: BrandService): BrandRepository {

    override suspend fun getAll(refresh: Boolean): Result<List<ProductProperty>> {
        return Result.Failure(FailureReason.INTERNAL_ERROR)
    }

    override suspend fun insert(brand: ProductProperty): Result<ProductProperty> =  try {
            val result = brandService.create(BrandEntity(brand))

            when(result.code()){
                200 -> {

                    val createdBrand = checkNotNull(result.body()){
                        return Result.Failure(FailureReason.INTERNAL_ERROR)
                    }
    
                    if(brandDao.insert(createdBrand) < 0L) {
                        Result.Failure(FailureReason.INTERNAL_ERROR)
                    } else {
                        Result.Success(createdBrand.mapToDomain())
                    }
                }
                401 -> Result.Failure(FailureReason.EXPIRED_TOKEN)
                403 -> Result.Failure(FailureReason.WRONG_VALUES_ON_PARAMETERS)
                else -> Result.Failure(FailureReason.INTERNAL_ERROR)
            }
        } catch(ex: Exception) {
            ex.printStackTrace()
            Result.Failure(FailureReason.INTERNAL_ERROR)
        }

    override suspend fun update(brand: ProductProperty): Result<ProductProperty> {
        return Result.Failure(FailureReason.INTERNAL_ERROR)
    }

    override suspend fun delete(brand: ProductProperty): Result<Boolean> {
        return Result.Failure(FailureReason.INTERNAL_ERROR)
    }
}