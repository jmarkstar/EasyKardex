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
 * Created by jmarkstar on 7/12/19 6:12 PM
 *
 */

package com.jmarkstar.easykardex.data.api

import com.jmarkstar.easykardex.data.entities.ProviderEntity
import retrofit2.Response
import retrofit2.http.*

internal interface ProviderService {

    @GET("providers")
    suspend fun getAll(@Query("lud") lastUpdateDate: String? = null): Response<List<ProviderEntity>>

    @GET("providers/{idProvider}")
    suspend fun findById(@Path("idProvider") idProvider: Long): Response<ProviderEntity>

    @POST("providers")
    suspend fun create(@Body newProvider: ProviderEntity): Response<ProviderEntity>

    @DELETE("providers/{idProvider}")
    suspend fun delete(@Path("idProvider") idProvider: Long): Response<Void>

    @PUT("providers/{idProvider}")
    suspend fun update(@Path("idProvider") idProvider: Long, @Body updatedProvider: ProviderEntity): Response<ProviderEntity>
}