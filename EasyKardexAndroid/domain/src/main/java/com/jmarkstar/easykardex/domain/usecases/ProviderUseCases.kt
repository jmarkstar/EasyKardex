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
 * Created by jmarkstar on 7/24/19 2:29 PM
 *
 */

package com.jmarkstar.easykardex.domain.usecases

import com.jmarkstar.easykardex.domain.datasources.ProviderRepository
import com.jmarkstar.easykardex.domain.models.Provider
import com.jmarkstar.easykardex.domain.models.Result

class InsertNewProviderUseCase(private val providerRepository: ProviderRepository) {
    suspend fun insert(provider: Provider): Result<Provider> = providerRepository.insert(provider)
}

class UpdateProviderUseCase(private val providerRepository: ProviderRepository) {
    suspend fun update(id: Long, provider: Provider): Result<Provider> = providerRepository.update(id, provider)
}

class DeleteProviderUseCase(private val providerRepository: ProviderRepository) {
    suspend fun delete(provider: Provider): Result<Boolean> = providerRepository.delete(provider)
}

class GetProvidersUseCase(private val providerRepository: ProviderRepository) {
    suspend fun getAll(refresh: Boolean = false): Result<List<Provider>> = providerRepository.getAll(refresh)
}

class GetProviderByIdUseCase(private val providerRepository: ProviderRepository) {
    suspend fun getProduct(id: Long): Result<Provider> = providerRepository.getProviderById(id)
}