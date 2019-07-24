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
 * Created by jmarkstar on 7/18/19 3:06 PM
 *
 */

package com.jmarkstar.easykardex.domain.di

import com.jmarkstar.easykardex.domain.usecases.*
import org.koin.core.module.Module
import org.koin.dsl.module

val useCaseModule: Module = module {

    //Account

    factory { LoginUseCase(accountRepository = get()) }
    factory { LogoutUseCase(accountRepository = get()) }
    factory { GetUserLoggedInUseCase(accountRepository = get()) }

    // Product Property

    factory { InsertNewProductPropertyUseCase(brandRepository = get(), categoryRepository = get(), unitRepository = get()) }
    factory { UpdateProductPropertyUseCase(brandRepository = get(), categoryRepository = get(), unitRepository = get()) }
    factory { DeleteProductPropertyUseCase(brandRepository = get(), categoryRepository = get(), unitRepository = get()) }
    factory { GetProductPropertiesUseCase(brandRepository = get(), categoryRepository = get(), unitRepository = get()) }
    factory { GetProductPropertyByIdUseCase(brandRepository = get(), categoryRepository = get(), unitRepository = get()) }

    // Product

    factory { InsertNewProductUseCase(productRepository = get()) }
    factory { UpdateProductUseCase(productRepository = get()) }
    factory { DeleteProductUseCase(productRepository = get()) }
    factory { GetProductsUseCase(productRepository = get()) }
    factory { GetProductByIdUseCase(productRepository = get()) }

    // Provider

    factory { InsertNewProviderUseCase(providerRepository = get()) }
    factory { UpdateProviderUseCase(providerRepository = get()) }
    factory { DeleteProviderUseCase(providerRepository = get()) }
    factory { GetProvidersUseCase(providerRepository = get()) }
    factory { GetProviderByIdUseCase(providerRepository = get()) }
}