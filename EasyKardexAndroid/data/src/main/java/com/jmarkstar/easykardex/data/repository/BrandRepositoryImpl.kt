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
import com.jmarkstar.easykardex.data.cache.EasyKardexCache
import com.jmarkstar.easykardex.data.database.daos.BrandDao
import com.jmarkstar.easykardex.data.entities.BrandEntity
import com.jmarkstar.easykardex.data.entities.EntityStatus
import com.jmarkstar.easykardex.data.entities.mapToDomain
import com.jmarkstar.easykardex.data.utils.LibraryUtils
import com.jmarkstar.easykardex.data.utils.processNetworkResult
import com.jmarkstar.easykardex.domain.datasources.BrandRepository
import com.jmarkstar.easykardex.domain.models.FailureReason
import com.jmarkstar.easykardex.domain.models.ProductProperty
import com.jmarkstar.easykardex.domain.models.Result
import java.util.*
import kotlin.collections.ArrayList

internal class BrandRepositoryImpl(private val cache: EasyKardexCache, private val brandDao: BrandDao, private val brandService: BrandService): BrandRepository {

    override suspend fun getBrands(refresh: Boolean): Result<List<ProductProperty>> {

        if(!refresh){
            val localBrands = brandDao.getBrands().mapToDomain()
            return Result.Success(localBrands)
        }

        val result = brandService.getAll(cache.brandsLastUpdateDate)

        return processNetworkResult(result.code()) {

            val newBrandsResult = result.body() ?: ArrayList()

            newBrandsResult.forEach {

                when(it.status) {
                    EntityStatus.ACTIVE -> brandDao.insert(it)
                    EntityStatus.INACTIVE -> {

                        if(it.id != null) {
                            brandDao.deleteBrandById(it.id)
                        }
                    }
                }
            }

            cache.brandsLastUpdateDate = LibraryUtils.dateTimeFormatter.format(Date())

            Result.Success(brandDao.getBrands().mapToDomain())
        }
    }


    override suspend fun insert(brand: ProductProperty): Result<ProductProperty> {

        val result = brandService.create(BrandEntity(brand))

        return processNetworkResult(result.code()) {

            val createdBrand = checkNotNull(result.body()){
                Result.Failure(FailureReason.INTERNAL_ERROR)
            }

            if(brandDao.insert(createdBrand) < 0L) {
                Result.Failure(FailureReason.DATABASE_OPERATION_ERROR)
            } else {
                Result.Success(createdBrand.mapToDomain())
            }
        }
    }

    override suspend fun update(id: Long, brand: ProductProperty): Result<ProductProperty> {

        val result = brandService.update(id, BrandEntity(brand) )

        return processNetworkResult(result.code()) {

            val updatedBrand = checkNotNull(result.body()){
                Result.Failure(FailureReason.INTERNAL_ERROR)
            }

            if(brandDao.insert(updatedBrand) < 0L) {
                Result.Failure(FailureReason.DATABASE_OPERATION_ERROR)
            } else {
                Result.Success(updatedBrand.mapToDomain())
            }
        }
    }

    override suspend fun delete(brand: ProductProperty): Result<Boolean> {

        val id = checkNotNull(brand.id){
            return Result.Failure(FailureReason.WRONG_VALUES_ON_PARAMETERS)
        }

        val result = brandService.delete(id)

        return processNetworkResult(result.code()) {

            if(brandDao.deleteBrandById(id) < 1L) {
                Result.Failure(FailureReason.DATABASE_OPERATION_ERROR)
            } else {
                Result.Success(result.isSuccessful)
            }
        }
    }
}