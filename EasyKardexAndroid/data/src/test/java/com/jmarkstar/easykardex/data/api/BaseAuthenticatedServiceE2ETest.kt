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
 * Created by jmarkstar on 8/2/19 8:10 PM
 *
 */

package com.jmarkstar.easykardex.data.api

import androidx.test.core.app.ApplicationProvider
import com.jmarkstar.easykardex.data.api.request.LoginRequest
import com.jmarkstar.easykardex.data.cache.EasyKardexCache
import com.jmarkstar.easykardex.data.di.cacheModule
import com.jmarkstar.easykardex.data.di.commonModule
import com.jmarkstar.easykardex.data.di.constantTestModule
import com.jmarkstar.easykardex.data.di.networkModule
import com.jmarkstar.easykardex.data.rightPassword
import com.jmarkstar.easykardex.data.rightUserName
import kotlinx.coroutines.runBlocking
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.startKoin
import org.koin.core.context.stopKoin
import org.koin.test.KoinTest
import org.koin.test.inject

abstract class BaseAuthenticatedServiceE2ETest: KoinTest {

    private val accountService: AccountService by inject()
    private val cache: EasyKardexCache by inject()

    @Before
    fun setupKoinModules(){
        println("setupKoinModules")
        startKoin {
            androidContext(ApplicationProvider.getApplicationContext())
            modules(listOf(commonModule, constantTestModule, networkModule, cacheModule))
        }
    }

    @Before
    fun login() = runBlocking {
        println("login")

        val request = LoginRequest(rightUserName, rightPassword)
        val result = accountService.login(request)

        assert(result.isSuccessful)

        cache.token = result.body()!!.token
    }

    @After
    fun logout() = runBlocking {
        println("logout")
        val logoutResult = accountService.logout()
        Assert.assertEquals(true, 204 == logoutResult.code())
        cache.token = null
    }

    @After
    fun stopKoinModules(){
        println("stopKoinModules")
        stopKoin()
    }
}