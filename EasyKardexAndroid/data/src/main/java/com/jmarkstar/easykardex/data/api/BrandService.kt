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

import com.jmarkstar.easykardex.data.entities.BrandEntity
import retrofit2.Response
import retrofit2.http.*

internal interface BrandService {

    @GET("brands")
    suspend fun getAll(@Query("lud") lastUpdateDate: String? = null): Response<List<BrandEntity>>

    @GET("brands/{idBrand}")
    suspend fun findById(@Path("idBrand") idBrand: Long): Response<BrandEntity>

    @POST("brands")
    suspend fun create(@Body newBrand: BrandEntity): Response<BrandEntity>

    @DELETE("brands/{idBrand}")
    suspend fun delete(@Path("idBrand") idBrand: Long): Response<Void>

    @PUT("brands/{idBrand}")
    suspend fun update(@Path("idBrand") idBrand: Long, @Body updatedBrand: BrandEntity): Response<BrandEntity>

}