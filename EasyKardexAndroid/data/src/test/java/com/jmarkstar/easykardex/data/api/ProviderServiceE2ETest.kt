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
 * Created by jmarkstar on 8/5/19 11:59 PM
 *
 */

package com.jmarkstar.easykardex.data.api

import android.os.Build
import com.jmarkstar.easykardex.data.entities.ProviderEntity
import com.jmarkstar.easykardex.data.provider
import com.jmarkstar.easykardex.data.utils.LibraryConstants
import kotlinx.coroutines.runBlocking
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.koin.test.inject
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [Build.VERSION_CODES.O_MR1])
class ProviderServiceE2ETest: BaseAuthenticatedServiceE2ETest() {

    private val providerService: ProviderService by inject()

    @Test
    fun `create and delete unit successly`() = runBlocking {

        //Create
        val newItem = create()

        //Delete
        delete(newItem.id!!)
    }

    @Test
    fun `create provider failure Empty name`() = runBlocking {

        val providerWithoutCompanyName = ProviderEntity(null, LibraryConstants.EMPTY, "Paul Smith","+610432654030")

        val createResult = providerService.create(providerWithoutCompanyName)

        Assert.assertEquals(true, createResult.code() == 400)
    }

    @Test
    fun `create provider success Empty contact info`() = runBlocking {

        val providerWithoutContactInfo = ProviderEntity(null, "Google AU", LibraryConstants.EMPTY,LibraryConstants.EMPTY)

        val createResult = providerService.create(providerWithoutContactInfo)

        println("http code: ${createResult.code()}")

        Assert.assertEquals(true, createResult.code() == 201)
    }

    @Test
    fun `update provider successly`() = runBlocking {

        val newItem = create()

        val id = newItem.id!!

        val newCompanyName = "Apple"
        newItem.companyName = newCompanyName

        val updateResult = providerService.update(id, newItem)

        Assert.assertEquals(true, updateResult.code() == 200)
        Assert.assertNotNull(updateResult.body())

        val updatedBrand = updateResult.body()!!

        Assert.assertTrue(updatedBrand.companyName == newCompanyName)

        delete(id)
    }

    @Test
    fun `update provider failure Empty name`() = runBlocking {

        val newItem = create()

        val id = newItem.id!!

        newItem.companyName = LibraryConstants.EMPTY

        val createResult = providerService.update(id, newItem)

        Assert.assertEquals(true, createResult.code() == 400)

        delete(id)
    }

    @Test
    fun `update provider failure Brand not found`() = runBlocking {

        val createResult = providerService.update(-1, provider)

        Assert.assertEquals(true, createResult.code() == 404)
    }

    @Test
    fun `delete provider failure Brand not found`() = runBlocking {

        val createResult = providerService.delete(-1)

        Assert.assertEquals(true, createResult.code() == 404)
    }

    @Test
    fun `get all providers success`() = runBlocking {

        val getAllResult = providerService.getAll()

        Assert.assertEquals(true, getAllResult.code() == 200)
        Assert.assertNotNull(getAllResult.body())
        Assert.assertEquals(true, getAllResult.body()!!.isNotEmpty())
    }

    @Test
    fun `get Provider by Id Success`() = runBlocking {

        val newItem = create()

        val newItemId = newItem.id!!

        val getByIdResult = providerService.findById(newItemId)

        Assert.assertEquals(true, getByIdResult.code() == 200)
        Assert.assertNotNull(getByIdResult.body())

        delete(newItemId)
    }

    @Test
    fun `get Provider by Id failure Not found`() = runBlocking {

        val createResult = providerService.findById(-1)

        Assert.assertEquals(true, createResult.code() == 404)
    }

    private suspend fun create(): ProviderEntity {

        val createResult = providerService.create(provider)

        Assert.assertEquals(true, createResult.code() == 201)
        Assert.assertNotNull(createResult.body())
        Assert.assertNotNull(createResult.body()?.id)

        //Update

        val newItem = createResult.body()!!

        Assert.assertTrue(newItem.companyName == provider.companyName)
        Assert.assertTrue(newItem.contactName == provider.contactName)
        Assert.assertTrue(newItem.contactPhoneNumber == provider.contactPhoneNumber)

        return newItem
    }

    private suspend fun delete(id: Long) {

        val deleteResult = providerService.delete(id)

        Assert.assertEquals(true, deleteResult.code() == 204)
    }
}