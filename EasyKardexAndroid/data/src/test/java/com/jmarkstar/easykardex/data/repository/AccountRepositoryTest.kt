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
 * Created by jmarkstar on 8/7/19 9:52 PM
 *
 */

package com.jmarkstar.easykardex.data.repository

import com.jmarkstar.easykardex.data.*
import com.jmarkstar.easykardex.data.api.AccountService
import com.jmarkstar.easykardex.data.api.request.LoginRequest
import com.jmarkstar.easykardex.data.api.response.LoginResponse
import com.jmarkstar.easykardex.data.cache.EasyKardexCache
import com.jmarkstar.easykardex.domain.models.FailureReason
import com.jmarkstar.easykardex.domain.models.Result
import kotlinx.coroutines.runBlocking
import okhttp3.ResponseBody
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.*
import retrofit2.Response
import java.net.SocketTimeoutException
import java.net.UnknownHostException

internal class AccountRepositoryTest {

    val accountService: AccountService = mock(AccountService::class.java)

    val cache: EasyKardexCache = mock(EasyKardexCache::class.java)

    lateinit var accountRepository: AccountRepositoryImpl

    @Before
    fun setup() {
        accountRepository = AccountRepositoryImpl(accountService, cache)
    }

    @Test
    fun `get user loggedIn success test`() = runBlocking {

        `when`(cache.userLoggedIn).thenReturn(userEntity)

        val result = accountRepository.getUserLoggedIn()

        assert(result is Result.Success)

        when(result){
            is Result.Success ->
                assert(result.value.username == userEntity.username)
        }
    }

    @Test
    fun `get user loggedIn failure test`() = runBlocking {

        val result = accountRepository.getUserLoggedIn()

        assert(result is Result.Failure)

        when(result){
            is Result.Failure ->
                assert(result.reason == FailureReason.THERE_IS_NOT_USER_LOGGED_IN)
        }
    }

    @Test
    fun `login success test`() = runBlocking {

        val request = LoginRequest(rightUserName, rightPassword)
        val responseLogin = Response.success(200, LoginResponse(rightToken, userEntity))

        `when`(accountService.login(request))
            .thenReturn(responseLogin)

        val result = accountRepository.login(rightUserName, rightPassword)

        assert(result is Result.Success)

        when(result){
            is Result.Success ->
                assert(result.value.username == userEntity.username)
        }
    }

    @Test
    fun `login failure Null body test`() = runBlocking {

        val request = LoginRequest(rightUserName, rightPassword)
        val responseLogin = Response.success<LoginResponse>(200, null)

        `when`(accountService.login(request))
            .thenReturn(responseLogin)

        val result = accountRepository.login(rightUserName, rightPassword)

        assert(result is Result.Failure)

        when(result){
            is Result.Failure ->
                assert(result.reason == FailureReason.INTERNAL_ERROR)
        }
    }

    @Test
    fun `login failure wrong username test`() = runBlocking {

        val request = LoginRequest(wrongUserName, rightPassword)
        val responseLogin = Response.error<LoginResponse>(404, ResponseBody.create(null, ""))

        `when`(accountService.login(request))
            .thenReturn(responseLogin)

        val result = accountRepository.login(wrongUserName, rightPassword)

        assert(result is Result.Failure)

        when(result){
            is Result.Failure ->
                assert(result.reason == FailureReason.WRONG_USER)
        }
    }

    @Test
    fun `login failure wrong password test`() = runBlocking {

        val request = LoginRequest(rightUserName, wrongPassword)
        val responseLogin = Response.error<LoginResponse>(401, ResponseBody.create(null, ""))

        `when`(accountService.login(request))
            .thenReturn(responseLogin)

        val result = accountRepository.login(rightUserName, wrongPassword)

        assert(result is Result.Failure)

        when(result){
            is Result.Failure ->
                assert(result.reason == FailureReason.WRONG_PASSWORD)
        }
    }

    @Test
    fun `login failure internal server error test`() = runBlocking {

        val request = LoginRequest(rightUserName, rightPassword)
        val responseLogin = Response.error<LoginResponse>(500, ResponseBody.create(null, ""))

        `when`(accountService.login(request))
            .thenReturn(responseLogin)

        val result = accountRepository.login(rightUserName, rightPassword)

        assert(result is Result.Failure)

        when(result){
            is Result.Failure ->
                assert(result.reason == FailureReason.INTERNAL_ERROR)
        }
    }

    @Test
    fun `login failure server not found test`() = runBlocking {

        val request = LoginRequest(rightUserName, rightPassword)

        `when`(accountService.login(request))
            .thenAnswer { throw UnknownHostException() }

        val result = accountRepository.login(rightUserName, rightPassword)

        assert(result is Result.Failure)

        when(result){
            is Result.Failure -> {
                assert(result.reason == FailureReason.SERVER_COULDNT_BE_FOUND)
            }
        }
    }

    @Test
    fun `login failure throw any exception test`() = runBlocking {

        val request = LoginRequest(rightUserName, rightPassword)

        `when`(accountService.login(request))
            .thenAnswer { throw SocketTimeoutException() }

        val result = accountRepository.login(rightUserName, rightPassword)

        assert(result is Result.Failure)

        when(result){
            is Result.Failure ->
                assert(result.reason == FailureReason.INTERNAL_ERROR)
        }
    }
}