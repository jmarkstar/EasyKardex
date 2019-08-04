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
 * Created by jmarkstar on 8/2/19 7:37 PM
 *
 */

package com.jmarkstar.easykardex.data.api

import android.os.Build
import com.jmarkstar.easykardex.data.brand
import com.jmarkstar.easykardex.data.entities.BrandEntity
import com.jmarkstar.easykardex.data.utils.LibraryConstants
import kotlinx.coroutines.runBlocking
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.koin.test.inject
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

/** Android context is needed on Logout.
 * */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [Build.VERSION_CODES.O_MR1])
class BrandServiceE2ETest: BaseAuthenticatedServiceE2ETest() {

    private val brandService: BrandService by inject()

    /** Because we are using the server, we dont want that new row exists as a normal row in the database. We must delete it.
     * */
    @Test
    fun `brand create and delete success`() = runBlocking {

        //Create
        val newBrand = createBrand()

        //Delete
        deleteBrand(newBrand.id!!)
    }

    @Test
    fun `brand create failure Empty name`() = runBlocking {

        val brandWithoutName = BrandEntity(name = LibraryConstants.EMPTY)

        val createResult = brandService.create(brandWithoutName)

        Assert.assertEquals(true, createResult.code() == 400)
    }

    @Test
    fun `brand update success`() = runBlocking {

        val newBrand = createBrand()

        val brandId = newBrand.id!!

        val newName = "Pepsi"
        newBrand.name = newName

        val updateResult = brandService.update(brandId, newBrand)

        Assert.assertEquals(true, updateResult.code() == 200)
        Assert.assertNotNull(updateResult.body())

        val updatedBrand = updateResult.body()!!

        Assert.assertTrue(updatedBrand.name == newName)

        deleteBrand(brandId)
    }

    @Test
    fun `brand update failure Empty name`() = runBlocking {

        val newBrand = createBrand()

        val brandId = newBrand.id!!

        newBrand.name = LibraryConstants.EMPTY

        val createResult = brandService.update(brandId, newBrand)

        Assert.assertEquals(true, createResult.code() == 400)

        deleteBrand(brandId)
    }

    @Test
    fun `brand update failure Brand not found`() = runBlocking {

        val createResult = brandService.update(-1, brand)

        Assert.assertEquals(true, createResult.code() == 404)
    }

    @Test
    fun `brand delete failure Brand not found`() = runBlocking {

        val createResult = brandService.delete(-1)

        Assert.assertEquals(true, createResult.code() == 404)
    }

    @Test
    fun `get all brands success`() = runBlocking {

        val getAllResult = brandService.getAll()

        Assert.assertEquals(true, getAllResult.code() == 200)
        Assert.assertNotNull(getAllResult.body())
        Assert.assertEquals(true, getAllResult.body()!!.isNotEmpty())
    }

    @Test
    fun `get Brand by Id Success`() = runBlocking {

        val newBrand = createBrand()

        val brandId = newBrand.id!!

        val getByIdResult = brandService.findById(brandId)

        Assert.assertEquals(true, getByIdResult.code() == 200)
        Assert.assertNotNull(getByIdResult.body())

        deleteBrand(brandId)
    }

    @Test
    fun `get Brand by Id failure Not found`() = runBlocking {

        val createResult = brandService.findById(-1)

        Assert.assertEquals(true, createResult.code() == 404)
    }

    private suspend fun createBrand(): BrandEntity {

        val createResult = brandService.create(brand)

        Assert.assertEquals(true, createResult.code() == 201)
        Assert.assertNotNull(createResult.body())
        Assert.assertNotNull(createResult.body()?.id)

        //Update

        val newBrand = createResult.body()!!

        Assert.assertTrue(newBrand.name == brand.name)

        return newBrand
    }

    private suspend fun deleteBrand(brandId: Long) {

        val deleteResult = brandService.delete(brandId)

        Assert.assertEquals(true, deleteResult.code() == 204)
    }
}