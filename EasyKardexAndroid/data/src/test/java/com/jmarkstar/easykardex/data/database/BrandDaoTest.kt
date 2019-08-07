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
 * Created by jmarkstar on 7/28/19 11:51 PM
 *
 */

package com.jmarkstar.easykardex.data.database

import android.os.Build
import com.jmarkstar.easykardex.data.brand
import com.jmarkstar.easykardex.data.brands
import com.jmarkstar.easykardex.data.database.daos.BrandDao
import kotlinx.coroutines.runBlocking
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.koin.test.inject
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [Build.VERSION_CODES.O_MR1])
class BrandDaoTest: BaseDaoTest() {

    private val brandDao: BrandDao by inject()

    @Test
    fun `insert brand success`()= runBlocking {
        val result = brandDao.insert(brand)
        assert(result > 0)
    }

    @Test
    fun `insert list of brands success`()= runBlocking {
        val result = brandDao.insertAll(brands.asList())
        result.forEach {
            assert(it > 0)
        }
    }

    @Test
    fun `get brand by id success`() = runBlocking {
        brandDao.insert(brand)
        val result = brandDao.getBrandById(1L)
        Assert.assertNotNull(result)
        Assert.assertTrue(result?.name == brand.name)
    }

    @Test
    fun `get all brands success`() = runBlocking {
        brandDao.insertAll(brands.asList())
        val list = brandDao.getBrands()
        Assert.assertNotNull(list)
        Assert.assertTrue(list.isNotEmpty())
    }

    @Test
    fun `get all brands empty`() = runBlocking {
        val list = brandDao.getBrands()
        Assert.assertNotNull(list)
        Assert.assertTrue(list.isEmpty())
    }

    @Test
    fun `delete brand by id success`() = runBlocking {
        brandDao.insert(brand)
        val result = brandDao.deleteBrandById(1L)
        Assert.assertTrue(result == 1)
    }

    @Test
    fun `delete brand by id fail`() = runBlocking {
        brandDao.insert(brand)
        val result = brandDao.deleteBrandById(5L)
        Assert.assertFalse(result == 1)
    }

    @Test
    fun `clean table success`() = runBlocking {
        val success = brandDao.insertAll(brands.asList())
        val result = brandDao.cleanTable()
        Assert.assertTrue("inserts: ${success.size} - deletes: $result",success.size == result)
    }
}