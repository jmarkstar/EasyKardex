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
 * Created by jmarkstar on 7/12/19 6:13 PM
 *
 */

package com.jmarkstar.easykardex.data.api

import com.jmarkstar.easykardex.data.entities.UnitEntity
import retrofit2.Response
import retrofit2.http.*

internal interface UnitService {

    @GET("units")
    suspend fun getAll(@Query("lud") creationAt: String? = null): Response<List<UnitEntity>>

    @GET("units/{idUnit}")
    suspend fun findById(@Path("idUnit") idUnit: Long): Response<UnitEntity>

    @POST("units")
    suspend fun create(@Body newBrand: UnitEntity): Response<UnitEntity>

    @DELETE("units/{idUnit}")
    suspend fun delete(@Path("idUnit") idUnit: Long): Response<Void>

    @PUT("units/{idUnit}")
    suspend fun update(@Path("idUnit") idUnit: Long, @Body updatedUnit: UnitEntity): Response<UnitEntity>
}