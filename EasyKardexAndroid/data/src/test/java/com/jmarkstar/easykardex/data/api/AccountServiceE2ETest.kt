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
 * Created by jmarkstar on 7/25/19 11:55 PM
 *
 */

package com.jmarkstar.easykardex.data.api

import android.os.Build
import com.jmarkstar.easykardex.data.*
import com.jmarkstar.easykardex.data.api.request.LoginRequest
import com.jmarkstar.easykardex.data.cache.EasyKardexCache
import com.jmarkstar.easykardex.data.entities.UserEntity
import com.jmarkstar.easykardex.data.utils.LibraryConstants
import com.jmarkstar.easykardex.data.utils.readFileAsString
import com.squareup.moshi.Moshi
import kotlinx.coroutines.runBlocking
import org.junit.*
import org.junit.runner.RunWith
import org.koin.test.inject
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

/** Android context is needed on Logout.
 * */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [Build.VERSION_CODES.O_MR1])
class AccountServiceE2ETest: BaseApiTest() {

    private val accountService: AccountService by inject()

    private val moshi: Moshi by inject()

    private val cache: EasyKardexCache by inject()

    @Test
    fun `login success test`() = runBlocking {

        val request = LoginRequest(rightUserName, rightPassword)

        val result = accountService.login(request)

        assert(result.isSuccessful)
        Assert.assertNotNull(result.body())
        Assert.assertNotNull(result.body()?.token)
        Assert.assertFalse(result.body()?.token == LibraryConstants.EMPTY)

        val userLoggedIn = readFileAsString(this@AccountServiceE2ETest.javaClass, "assets/UserLoggedInUser.json")

        val userAdapter = moshi.adapter(UserEntity::class.java)
        val userResponseJson = userAdapter.toJson(result.body()!!.user)

        Assert.assertFalse(userLoggedIn == userResponseJson)
    }

    @Test
    fun `login failure user doesnt exist test`() = runBlocking {

        val request = LoginRequest(wrongUserName, rightPassword)

        val result = accountService.login(request)

        Assert.assertFalse(result.isSuccessful)
        Assert.assertEquals(true, 404 == result.code())

        Assert.assertNull(result.body())
    }

    @Test
    fun `login failure wrong password test`() = runBlocking {

        val request = LoginRequest(rightUserName, wrongPassword)

        val result = accountService.login(request)

        Assert.assertFalse(result.isSuccessful)
        Assert.assertEquals(true, 401 == result.code())
    }

    @Test
    fun `logout success test`() = runBlocking {

        val request = LoginRequest(rightUserName,rightPassword)

        val loginResult = accountService.login(request)

        assert(loginResult.isSuccessful)

        cache.token = loginResult.body()?.token

        val logoutResult = accountService.logout()

        Assert.assertEquals(true, 204 == logoutResult.code())

        cache.token = null
    }

    @Test
    fun `logout failure Token not provided test`() = runBlocking {

        val logoutResult = accountService.logout()
        Assert.assertEquals(true, 400 == logoutResult.code())
    }

    @Test
    fun `logout failure Wrong token test`() = runBlocking {

        cache.token = wrongToken
        val logoutResult = accountService.logout()
        Assert.assertEquals(true, 401 == logoutResult.code())
    }
}