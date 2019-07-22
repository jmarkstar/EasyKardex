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
 * Created by jmarkstar on 7/12/19 6:11 PM
 *
 */

package com.jmarkstar.easykardex.data.api

import com.jmarkstar.easykardex.data.entities.CategoryEntity
import retrofit2.http.*

internal interface CategoryService {

    @GET("categories")
    suspend fun getAll(@Query("cd") creationAt: String): List<CategoryEntity>

    @GET("categories/{idCategory}")
    suspend fun findById(@Path("idCategory") idCategory: Long): CategoryEntity?

    @POST("categories")
    suspend fun create(@Body newBrand: CategoryEntity): CategoryEntity

    @DELETE("categories/{idCategory}")
    suspend fun delete(@Path("idCategory") idCategory: Long)

    @PUT("categories/{idCategory}")
    suspend fun update(@Path("idCategory") idCategory: Long, @Body updatedCategory: CategoryEntity): CategoryEntity
}