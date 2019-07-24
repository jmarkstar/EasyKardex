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

import com.jmarkstar.easykardex.domain.datasources.ProductRepository
import com.jmarkstar.easykardex.domain.models.Product
import com.jmarkstar.easykardex.domain.models.Result

class InsertNewProductUseCase(private val productRepository: ProductRepository) {
    suspend fun insert(product: Product): Result<Product> = productRepository.insert(product)
}

class UpdateProductUseCase(private val productRepository: ProductRepository) {
    suspend fun update(id: Long, product: Product): Result<Product> = productRepository.update(id, product)
}

class DeleteProductUseCase(private val productRepository: ProductRepository) {
    suspend fun delete(product: Product): Result<Boolean> = productRepository.delete(product)
}

class GetProductsUseCase(private val productRepository: ProductRepository) {
    suspend fun getAll(refresh: Boolean = false): Result<List<Product>> = productRepository.getAll(refresh)
}

class GetProductByIdUseCase(private val productRepository: ProductRepository) {
    suspend fun getProduct(id: Long): Result<Product> = productRepository.getProductById(id)
}