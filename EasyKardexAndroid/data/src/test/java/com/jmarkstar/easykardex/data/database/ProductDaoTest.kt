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
 * Created by jmarkstar on 8/7/19 9:17 PM
 *
 */

package com.jmarkstar.easykardex.data.database

import android.os.Build
import com.jmarkstar.easykardex.data.*
import com.jmarkstar.easykardex.data.database.daos.BrandDao
import com.jmarkstar.easykardex.data.database.daos.CategoryDao
import com.jmarkstar.easykardex.data.database.daos.ProductDao
import com.jmarkstar.easykardex.data.database.daos.UnitDao
import kotlinx.coroutines.runBlocking
import org.junit.After
import org.junit.Before
import org.junit.runner.RunWith
import org.koin.test.inject
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.junit.Assert
import org.junit.Test

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [Build.VERSION_CODES.O_MR1])
class ProductDaoTest: BaseDaoTest() {

    private val brandDao: BrandDao by inject()
    private val categoryDao: CategoryDao by inject()
    private val unitDao: UnitDao by inject()
    private val productDao: ProductDao by inject()

    @Before
    fun insertBrand() = runBlocking {
        val result = brandDao.insert(brand)
        assert(result > 0)
    }

    @Before
    fun insertCategory() = runBlocking {
        val result = categoryDao.insert(category)
        assert(result > 0)
    }

    @Before
    fun insertUnit() = runBlocking {
        val result = unitDao.insert(unit)
        assert(result > 0)
    }

    @After
    fun deleteBrand() = runBlocking {
        val result = brandDao.deleteBrandById(1L)
        Assert.assertTrue(result == 1)
    }

    @After
    fun deleteCategory() = runBlocking {
        val result = categoryDao.deleteCategoryById(1L)
        Assert.assertTrue(result == 1)
    }

    @After
    fun deleteUnit() = runBlocking {
        val result = unitDao.deleteUnitById(1L)
        Assert.assertTrue(result == 1)
    }

    @Test
    fun `insert product success`()= runBlocking {
        val result = productDao.insert(product)
        assert(result > 0)
    }

    @Test
    fun `insert list of products success`()= runBlocking {
        val result = productDao.insertAll(products.asList())
        result.forEach {
            assert(it > 0)
        }
    }

    @Test
    fun `get product by id success`() = runBlocking {
        productDao.insert(product)
        val result = productDao.getProductById(1L)
        Assert.assertNotNull(result)
        Assert.assertTrue(result?.name == product.name)
    }

    @Test
    fun `get all products success`() = runBlocking {
        productDao.insertAll(products.asList())
        val list = productDao.getProducts()
        Assert.assertNotNull(list)
        Assert.assertTrue(list.isNotEmpty())
    }

    @Test
    fun `get all products empty`() = runBlocking {
        val list = productDao.getProducts()
        Assert.assertNotNull(list)
        Assert.assertTrue(list.isEmpty())
    }

    @Test
    fun `delete product by id success`() = runBlocking {
        productDao.insert(product)
        val result = productDao.deleteProductById(1L)
        Assert.assertTrue(result == 1)
    }

    @Test
    fun `delete product by id fail`() = runBlocking {
        productDao.insert(product)
        val result = productDao.deleteProductById(5L)
        Assert.assertFalse(result == 1)
    }

    @Test
    fun `clean table success`() = runBlocking {
        val success = productDao.insertAll(products.asList())
        val result = productDao.cleanTable()
        Assert.assertTrue("inserts: ${success.size} - deletes: $result",success.size == result)
    }
}