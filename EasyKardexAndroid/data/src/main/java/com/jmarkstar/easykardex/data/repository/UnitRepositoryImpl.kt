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
 * Created by jmarkstar on 7/22/19 2:50 PM
 *
 */

package com.jmarkstar.easykardex.data.repository

import com.jmarkstar.easykardex.data.api.UnitService
import com.jmarkstar.easykardex.data.cache.EasyKardexCache
import com.jmarkstar.easykardex.data.database.daos.UnitDao
import com.jmarkstar.easykardex.data.entities.EntityStatus
import com.jmarkstar.easykardex.data.entities.UnitEntity
import com.jmarkstar.easykardex.data.entities.mapToDomain
import com.jmarkstar.easykardex.data.utils.LibraryUtils
import com.jmarkstar.easykardex.data.api.processError
import com.jmarkstar.easykardex.data.api.processNetworkResult
import com.jmarkstar.easykardex.domain.datasources.UnitRepository
import com.jmarkstar.easykardex.domain.models.FailureReason
import com.jmarkstar.easykardex.domain.models.ProductProperty
import com.jmarkstar.easykardex.domain.models.Result
import java.util.*
import kotlin.collections.ArrayList

internal class UnitRepositoryImpl(private val cache: EasyKardexCache,
                                  private val unitDao: UnitDao,
                                  private val unitService: UnitService): UnitRepository {

    override suspend fun getAll(refresh: Boolean): Result<List<ProductProperty>> = try {

        if(!refresh){
            val localItems = unitDao.getUnits().mapToDomain()
            Result.Success(localItems)
        }

        val result = unitService.getAll(cache.unitsLastUpdateDate)

        processNetworkResult(result.code()) {

            val newItemsResult = result.body() ?: ArrayList()

            newItemsResult.forEach {

                when(it.status) {
                    EntityStatus.ACTIVE -> unitDao.insert(it)
                    EntityStatus.INACTIVE -> {

                        if(it.id != null) {
                            unitDao.deleteUnitById(it.id)
                        }
                    }
                }
            }

            cache.unitsLastUpdateDate = LibraryUtils.dateTimeFormatter.format(Date())

            Result.Success(unitDao.getUnits().mapToDomain())
        }
    } catch (ex: Exception) {
        processError(ex)
    }

    override suspend fun insert(unit: ProductProperty): Result<ProductProperty> = try {

        val result = unitService.create(UnitEntity(unit))

        processNetworkResult(result.code()) {

            val createdItem = checkNotNull(result.body()){
                Result.Failure(FailureReason.INTERNAL_ERROR)
            }

            if(unitDao.insert(createdItem) < 0L) {
                Result.Failure(FailureReason.DATABASE_OPERATION_ERROR)
            } else {
                Result.Success(createdItem.mapToDomain())
            }
        }
    } catch (ex: Exception) {
        processError(ex)
    }

    override suspend fun update(id: Long, unit: ProductProperty): Result<ProductProperty> = try {

        val result = unitService.update(id, UnitEntity(unit) )

        processNetworkResult(result.code()) {

            val updatedItem = checkNotNull(result.body()){
                Result.Failure(FailureReason.INTERNAL_ERROR)
            }

            if(unitDao.insert(updatedItem) < 0L) {
                Result.Failure(FailureReason.DATABASE_OPERATION_ERROR)
            } else {
                Result.Success(updatedItem.mapToDomain())
            }
        }
    } catch (ex: Exception) {
        processError(ex)
    }

    override suspend fun delete(unit: ProductProperty): Result<Boolean> = try {

        val id = checkNotNull(unit.id){
            return Result.Failure(FailureReason.WRONG_VALUES_ON_PARAMETERS)
        }

        val result = unitService.delete(id)

        processNetworkResult(result.code()) {

            if(unitDao.deleteUnitById(id) < 1L) {
                Result.Failure(FailureReason.DATABASE_OPERATION_ERROR)
            } else {
                Result.Success(result.isSuccessful)
            }
        }
    } catch (ex: Exception) {
        processError(ex)
    }

    override suspend fun getUnitById(id: Long): Result<ProductProperty> = try {

        val localItem = unitDao.getUnitById(id)

        if(localItem != null){
            Result.Success(localItem.mapToDomain())
        }

        val result = unitService.findById(id)

        processNetworkResult(result.code()) {

            val foundItem = checkNotNull(result.body()){
                Result.Failure(FailureReason.INTERNAL_ERROR)
            }

            Result.Success(foundItem.mapToDomain())
        }
    } catch (ex: Exception){
        processError(ex)
    }


}