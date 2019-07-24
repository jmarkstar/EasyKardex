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

import com.jmarkstar.easykardex.data.api.CategoryService
import com.jmarkstar.easykardex.data.cache.EasyKardexCache
import com.jmarkstar.easykardex.data.database.daos.CategoryDao
import com.jmarkstar.easykardex.data.entities.CategoryEntity
import com.jmarkstar.easykardex.data.entities.EntityStatus
import com.jmarkstar.easykardex.data.entities.mapToDomain
import com.jmarkstar.easykardex.data.utils.LibraryUtils
import com.jmarkstar.easykardex.data.api.processError
import com.jmarkstar.easykardex.data.api.processNetworkResult
import com.jmarkstar.easykardex.domain.datasources.CategoryRepository
import com.jmarkstar.easykardex.domain.models.FailureReason
import com.jmarkstar.easykardex.domain.models.ProductProperty
import com.jmarkstar.easykardex.domain.models.Result
import java.util.*
import kotlin.collections.ArrayList

internal class CategoryRepositoryImpl(private val cache: EasyKardexCache,
                                      private val categoryDao: CategoryDao,
                                      private val categoryService: CategoryService): CategoryRepository {

    override suspend fun getAll(refresh: Boolean): Result<List<ProductProperty>> = try {

        if(!refresh){
            val localItems = categoryDao.getCategories().mapToDomain()
            Result.Success(localItems)
        }

        val result = categoryService.getAll(cache.categoriesLastUpdateDate)

        processNetworkResult(result.code()) {

            val newItemsResult = result.body() ?: ArrayList()

            newItemsResult.forEach {

                when(it.status) {
                    EntityStatus.ACTIVE -> categoryDao.insert(it)
                    EntityStatus.INACTIVE -> {

                        if(it.id != null) {
                            categoryDao.deleteCategoryById(it.id)
                        }
                    }
                }
            }

            cache.categoriesLastUpdateDate = LibraryUtils.dateTimeFormatter.format(Date())

            Result.Success(categoryDao.getCategories().mapToDomain())
        }
    } catch (ex: Exception) {
        processError(ex)
    }

    override suspend fun insert(category: ProductProperty): Result<ProductProperty> = try {

        val result = categoryService.create(CategoryEntity(category))

        processNetworkResult(result.code()) {

            val createdItem = checkNotNull(result.body()){
                Result.Failure(FailureReason.INTERNAL_ERROR)
            }

            if(categoryDao.insert(createdItem) < 0L) {
                Result.Failure(FailureReason.DATABASE_OPERATION_ERROR)
            } else {
                Result.Success(createdItem.mapToDomain())
            }
        }
    } catch (ex: Exception) {
        processError(ex)
    }

    override suspend fun update(id: Long, category: ProductProperty): Result<ProductProperty> = try {

        val result = categoryService.update(id, CategoryEntity(category) )

        processNetworkResult(result.code()) {

            val updatedItem = checkNotNull(result.body()){
                Result.Failure(FailureReason.INTERNAL_ERROR)
            }

            if(categoryDao.insert(updatedItem) < 0L) {
                Result.Failure(FailureReason.DATABASE_OPERATION_ERROR)
            } else {
                Result.Success(updatedItem.mapToDomain())
            }
        }
    } catch (ex: Exception) {
        processError(ex)
    }

    override suspend fun delete(category: ProductProperty): Result<Boolean> = try {

        val id = checkNotNull(category.id){
            return Result.Failure(FailureReason.WRONG_VALUES_ON_PARAMETERS)
        }

        val result = categoryService.delete(id)

        processNetworkResult(result.code()) {

            if(categoryDao.deleteCategoryById(id) < 1L) {
                Result.Failure(FailureReason.DATABASE_OPERATION_ERROR)
            } else {
                Result.Success(result.isSuccessful)
            }
        }
    } catch (ex: Exception) {
        processError(ex)
    }

    override suspend fun getCategoryById(id: Long): Result<ProductProperty> = try {

        val localItem = categoryDao.getCategoryById(id)

        if(localItem != null){
            Result.Success(localItem.mapToDomain())
        }

        val result = categoryService.findById(id)

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