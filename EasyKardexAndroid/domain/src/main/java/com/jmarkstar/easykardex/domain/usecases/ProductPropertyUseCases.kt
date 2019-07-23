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
 * Created by jmarkstar on 7/22/19 2:40 PM
 *
 */

package com.jmarkstar.easykardex.domain.usecases

import com.jmarkstar.easykardex.domain.datasources.BrandRepository
import com.jmarkstar.easykardex.domain.datasources.CategoryRepository
import com.jmarkstar.easykardex.domain.datasources.UnitRepository
import com.jmarkstar.easykardex.domain.models.ProductProperty
import com.jmarkstar.easykardex.domain.models.ProductPropertyType
import com.jmarkstar.easykardex.domain.models.Result

class InsertNewProductPropertyUseCase(private val brandRepository: BrandRepository, private val categoryRepository: CategoryRepository, private val unitRepository: UnitRepository){

    suspend fun insert(productProperty: ProductProperty): Result<ProductProperty> {
        return when (productProperty.type) {
            ProductPropertyType.BRAND -> brandRepository.insert(productProperty)
            ProductPropertyType.CATEGORY -> categoryRepository.insert(productProperty)
            ProductPropertyType.UNIT -> unitRepository.insert(productProperty)
        }
    }
}

class UpdateProductPropertyUseCase(private val  brandRepository: BrandRepository, private val  categoryRepository: CategoryRepository, private val  unitRepository: UnitRepository){

    suspend fun update(propertyId: Long, productProperty: ProductProperty): Result<ProductProperty> {
        return when (productProperty.type) {
            ProductPropertyType.BRAND -> brandRepository.update(propertyId, productProperty)
            ProductPropertyType.CATEGORY -> categoryRepository.update(propertyId, productProperty)
            ProductPropertyType.UNIT -> unitRepository.update(propertyId, productProperty)
        }
    }
}

class DeleteProductPropertyUseCase(private val  brandRepository: BrandRepository, private val  categoryRepository: CategoryRepository, private val  unitRepository: UnitRepository){

    suspend fun delete(productProperty: ProductProperty): Result<Boolean> {
        return when (productProperty.type) {
            ProductPropertyType.BRAND -> brandRepository.delete(productProperty)
            ProductPropertyType.CATEGORY -> categoryRepository.delete(productProperty)
            ProductPropertyType.UNIT -> unitRepository.delete(productProperty)
        }
    }
}

class GetProductPropertiesUseCase(private val  brandRepository: BrandRepository, private val  categoryRepository: CategoryRepository, private val  unitRepository: UnitRepository){

    suspend fun getAll(propertyType: ProductPropertyType, refresh: Boolean = false) : Result<List<ProductProperty>> {
        return when (propertyType) {
            ProductPropertyType.BRAND -> brandRepository.getAll(refresh)
            ProductPropertyType.CATEGORY -> categoryRepository.getAll(refresh)
            ProductPropertyType.UNIT -> unitRepository.getAll(refresh)
        }
    }
}