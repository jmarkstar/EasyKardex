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
 * Created by jmarkstar on 8/5/19 1:19 AM
 *
 */

package com.jmarkstar.easykardex.data.api

import android.os.Build
import com.jmarkstar.easykardex.data.entities.CategoryEntity
import org.junit.Assert
import org.junit.runner.RunWith
import org.koin.test.inject
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import com.jmarkstar.easykardex.data.category
import com.jmarkstar.easykardex.data.utils.LibraryConstants
import kotlinx.coroutines.runBlocking
import org.junit.Test

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [Build.VERSION_CODES.O_MR1])
class CategoryServiceE2ETest: BaseAuthenticatedServiceE2ETest() {

    private val categoryService: CategoryService by inject()

    @Test
    fun `create and delete category successly`() = runBlocking {

        //Create
        val newItem = create()

        //Delete
        delete(newItem.id!!)
    }

    @Test
    fun `create category failure Empty name`() = runBlocking {

        val brandWithoutName = CategoryEntity(name = LibraryConstants.EMPTY)

        val createResult = categoryService.create(brandWithoutName)

        Assert.assertEquals(true, createResult.code() == 400)
    }

    @Test
    fun `update category successly`() = runBlocking {

        val newItem = create()

        val id = newItem.id!!

        val newName = "Technology"
        newItem.name = newName

        val updateResult = categoryService.update(id, newItem)

        Assert.assertEquals(true, updateResult.code() == 200)
        Assert.assertNotNull(updateResult.body())

        val updatedBrand = updateResult.body()!!

        Assert.assertTrue(updatedBrand.name == newName)

        delete(id)
    }

    @Test
    fun `update category failure Empty name`() = runBlocking {

        val newItem = create()

        val id = newItem.id!!

        newItem.name = LibraryConstants.EMPTY

        val createResult = categoryService.update(id, newItem)

        Assert.assertEquals(true, createResult.code() == 400)

        delete(id)
    }

    @Test
    fun `update category failure Brand not found`() = runBlocking {

        val createResult = categoryService.update(-1, category)

        Assert.assertEquals(true, createResult.code() == 404)
    }

    @Test
    fun `delete category failure Brand not found`() = runBlocking {

        val createResult = categoryService.delete(-1)

        Assert.assertEquals(true, createResult.code() == 404)
    }

    @Test
    fun `get all categories success`() = runBlocking {

        val getAllResult = categoryService.getAll()

        Assert.assertEquals(true, getAllResult.code() == 200)
        Assert.assertNotNull(getAllResult.body())
        Assert.assertEquals(true, getAllResult.body()!!.isNotEmpty())
    }

    @Test
    fun `get Category by Id Success`() = runBlocking {

        val newBrand = create()

        val brandId = newBrand.id!!

        val getByIdResult = categoryService.findById(brandId)

        Assert.assertEquals(true, getByIdResult.code() == 200)
        Assert.assertNotNull(getByIdResult.body())

        delete(brandId)
    }

    @Test
    fun `get Category by Id failure Not found`() = runBlocking {

        val createResult = categoryService.findById(-1)

        Assert.assertEquals(true, createResult.code() == 404)
    }

    private suspend fun create(): CategoryEntity {

        val createResult = categoryService.create(category)

        Assert.assertEquals(true, createResult.code() == 201)
        Assert.assertNotNull(createResult.body())
        Assert.assertNotNull(createResult.body()?.id)

        //Update

        val newItem = createResult.body()!!

        Assert.assertTrue(newItem.name == category.name)

        return newItem
    }

    private suspend fun delete(id: Long) {

        val deleteResult = categoryService.delete(id)

        Assert.assertEquals(true, deleteResult.code() == 204)
    }
}