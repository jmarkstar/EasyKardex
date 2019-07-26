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
 * Created by jmarkstar on 7/26/19 11:35 AM
 *
 */

package com.jmarkstar.easykardex.data.entities.adapters

import com.jmarkstar.easykardex.data.di.constantTestModule
import com.jmarkstar.easykardex.data.di.networkModule
import com.jmarkstar.easykardex.data.entities.UserEntity
import com.jmarkstar.easykardex.data.utils.LibraryUtils
import com.jmarkstar.easykardex.data.utils.readFileAsString
import com.squareup.moshi.Moshi
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.koin.core.context.startKoin
import org.koin.core.context.stopKoin
import org.koin.test.KoinTest
import org.koin.test.inject
import org.threeten.bp.LocalDateTime

class LocalDateTimeAdapterTest: KoinTest {

    private val moshi: Moshi by inject()

    @Before
    fun setupKoinModules(){

        startKoin {
            modules(listOf(constantTestModule, networkModule))
        }
    }

    @Test
    fun `parse String to LocalDateTime success`(){

        val datetimeString = "2019-07-24 02:33:09"
        val zonedDateTime = LocalDateTime.parse(datetimeString, LibraryUtils.localDateTimeFormater)
        Assert.assertNotNull(zonedDateTime)
    }

    @Test
    fun `parse LocalDateTime to String success`(){

        val localDateTime = LocalDateTime.now()
        val string = LibraryUtils.localDateTimeFormater.format(localDateTime)
        Assert.assertNotNull(string)
    }

    @Test
    fun `parse user entity success`() {
        val userLoggedIn = readFileAsString(this@LocalDateTimeAdapterTest.javaClass, "assets/UserLoggedInUser.json")
        val userAdapter = moshi.adapter(UserEntity::class.java)
        val userResponseJson = userAdapter.fromJson(userLoggedIn)

        Assert.assertNotNull(userResponseJson)
    }


    @After
    fun stopKoinModules(){
        stopKoin()
    }
}