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
 * Created by jmarkstar on 7/18/19 1:22 PM
 *
 */

package com.jmarkstar.easykardex.data.di

import androidx.room.Room
import com.jmarkstar.easykardex.data.api.*
import com.jmarkstar.easykardex.data.api.AccountService
import com.jmarkstar.easykardex.data.api.CategoryService
import com.jmarkstar.easykardex.data.api.ProductInputService
import com.jmarkstar.easykardex.data.api.ProductOutputService
import com.jmarkstar.easykardex.data.api.ProductService
import com.jmarkstar.easykardex.data.cache.EasyKardexCache
import com.jmarkstar.easykardex.data.database.EasyKardexDatabase
import com.jmarkstar.easykardex.data.entities.adapters.EntityStatusAdapter
import com.jmarkstar.easykardex.data.entities.adapters.LocalDateTimeAdapter
import com.jmarkstar.easykardex.data.entities.adapters.UserRoleAdapter
import com.jmarkstar.easykardex.data.repository.AccountRepositoryImpl
import com.jmarkstar.easykardex.data.repository.BrandRepositoryImpl
import com.jmarkstar.easykardex.data.repository.CategoryRepositoryImpl
import com.jmarkstar.easykardex.data.repository.UnitRepositoryImpl
import com.jmarkstar.easykardex.domain.datasources.AccountRepository
import com.jmarkstar.easykardex.domain.datasources.BrandRepository
import com.jmarkstar.easykardex.domain.datasources.CategoryRepository
import com.jmarkstar.easykardex.domain.datasources.UnitRepository
import com.squareup.moshi.Moshi
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import org.koin.android.ext.koin.androidContext
import org.koin.core.module.Module
import org.koin.core.qualifier.named
import org.koin.dsl.module
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory

/** Repository Module */

val repositoryModule: Module = module {

    single<AccountRepository> { AccountRepositoryImpl(accountService = get(), cache =  get()) }
    single<BrandRepository> { BrandRepositoryImpl( cache =  get(), brandDao = get(), brandService = get()) }
    single<CategoryRepository> { CategoryRepositoryImpl( cache =  get(), categoryDao = get(), categoryService = get()) }
    single<UnitRepository> { UnitRepositoryImpl( cache =  get(), unitDao = get(), unitService = get()) }
}

/** Cache Module */

val cacheModule: Module = module {
    single { EasyKardexCache(context = androidContext(), moshi = get()) }
}

/** Database Module */

val daoModule: Module = module {

    single { get<EasyKardexDatabase>().brandDao }
    single { get<EasyKardexDatabase>().categoryDao }
    single { get<EasyKardexDatabase>().productDao }
    single { get<EasyKardexDatabase>().unitDao }
    single { get<EasyKardexDatabase>().providerDao }
    //single { get<EasyKardexDatabase>().brandDao }
    //single { get<EasyKardexDatabase>().brandDao }

}

val databaseModule: Module = module {

    single {
        Room.databaseBuilder(androidContext(), EasyKardexDatabase::class.java, "easykardex-db")
            .build()
    }
}

/** Network Module */

val networkModule: Module = module {

    //Services

    single { get<Retrofit>().create(AccountService::class.java) }
    single { get<Retrofit>().create(BrandService::class.java) }
    single { get<Retrofit>().create(CategoryService::class.java) }
    single { get<Retrofit>().create(ProductInputService::class.java) }
    single { get<Retrofit>().create(ProductOutputService::class.java) }
    single { get<Retrofit>().create(ProductService::class.java) }
    single { get<Retrofit>().create(ProviderService::class.java) }
    single { get<Retrofit>().create(UnitService::class.java) }

    //HTTP Client

    single {

        val httpLoggingInterceptor = HttpLoggingInterceptor(HttpLoggingInterceptor.Logger.DEFAULT)
        val clientBuilder = OkHttpClient.Builder()
        if (get(named("debug"))) {
            httpLoggingInterceptor.level = HttpLoggingInterceptor.Level.BODY
            clientBuilder.addInterceptor(httpLoggingInterceptor)
        }
        clientBuilder.build()
    }

    single {

        Retrofit.Builder()
            .baseUrl(get<String>(named("baseUrl")))
            .client(get())
            .addConverterFactory(MoshiConverterFactory.create(get()))
            .build()
    }
}

val commonModule: Module = module {

    single {
        Moshi.Builder()
            .add(UserRoleAdapter())
            .add(EntityStatusAdapter())
            .add(LocalDateTimeAdapter())
            .build()
    }
}
