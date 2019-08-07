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
 * Created by jmarkstar on 8/7/19 8:59 PM
 *
 */

package com.jmarkstar.easykardex.data.database

import android.os.Build
import com.jmarkstar.easykardex.data.database.daos.UnitDao
import com.jmarkstar.easykardex.data.unit
import com.jmarkstar.easykardex.data.units
import kotlinx.coroutines.runBlocking
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.koin.test.inject
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [Build.VERSION_CODES.O_MR1])
class UnitDaoTest: BaseDaoTest() {

    private val unitDao: UnitDao by inject()

    @Test
    fun `insert category success`()= runBlocking {
        val result = unitDao.insert(unit)
        assert(result > 0)
    }

    @Test
    fun `insert list of categories success`()= runBlocking {
        val result = unitDao.insertAll(units.asList())
        result.forEach {
            assert(it > 0)
        }
    }

    @Test
    fun `get category by id success`() = runBlocking {
        unitDao.insert(unit)
        val result = unitDao.getUnitById(1L)
        Assert.assertNotNull(result)
        Assert.assertTrue(result?.name == unit.name)
    }

    @Test
    fun `get all categories success`() = runBlocking {
        unitDao.insertAll(units.asList())
        val list = unitDao.getUnits()
        Assert.assertNotNull(list)
        Assert.assertTrue(list.isNotEmpty())
    }

    @Test
    fun `get all categories empty`() = runBlocking {
        val list = unitDao.getUnits()
        Assert.assertNotNull(list)
        Assert.assertTrue(list.isEmpty())
    }

    @Test
    fun `delete category by id success`() = runBlocking {
        unitDao.insert(unit)
        val result = unitDao.deleteUnitById(1L)
        Assert.assertTrue(result == 1)
    }

    @Test
    fun `delete category by id fail`() = runBlocking {
        unitDao.insert(unit)
        val result = unitDao.deleteUnitById(5L)
        Assert.assertFalse(result == 1)
    }

    @Test
    fun `clean table success`() = runBlocking {
        val success = unitDao.insertAll(units.asList())
        val result = unitDao.cleanTable()
        Assert.assertTrue("inserts: ${success.size} - deletes: $result",success.size == result)
    }
}