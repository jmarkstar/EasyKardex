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
 * Created by jmarkstar on 7/18/19 2:18 PM
 *
 */

package com.jmarkstar.easykardex.data.database

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.jmarkstar.easykardex.data.database.daos.*
import com.jmarkstar.easykardex.data.database.daos.BrandDao
import com.jmarkstar.easykardex.data.database.daos.CategoryDao
import com.jmarkstar.easykardex.data.database.daos.ProductDao
import com.jmarkstar.easykardex.data.database.daos.UnitDao
import com.jmarkstar.easykardex.data.entities.*

@Database(entities = [
        BrandEntity::class,
        CategoryEntity::class,
        UnitEntity::class,
        ProductEntity::class,
        ProviderEntity::class,
        ProductInputEntity::class,
        ProductOutputEntity::class
    ],
    version = 1,
    exportSchema = false)
@TypeConverters(Converters::class)
internal abstract class EasyKardexDatabase: RoomDatabase() {

    abstract val brandDao: BrandDao
    abstract val categoryDao: CategoryDao
    abstract val unitDao: UnitDao
    abstract val productDao: ProductDao
    abstract val providerDao: ProviderDao
    //abstract val brandDao: BrandDao
    //abstract val brandDao: BrandDao

}