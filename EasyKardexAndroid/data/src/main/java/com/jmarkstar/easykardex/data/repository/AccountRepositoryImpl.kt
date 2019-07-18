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
 * Created by jmarkstar on 7/15/19 8:02 PM
 *
 */

package com.jmarkstar.easykardex.data.repository

import com.jmarkstar.easykardex.data.api.AccountService
import com.jmarkstar.easykardex.data.api.request.LoginRequest
import com.jmarkstar.easykardex.data.cache.EasyKardexCache
import com.jmarkstar.easykardex.data.entities.mapToDomain
import com.jmarkstar.easykardex.domain.datasources.AccountRepository
import com.jmarkstar.easykardex.domain.datasources.FailureReason
import com.jmarkstar.easykardex.domain.datasources.Result
import com.jmarkstar.easykardex.domain.models.User
import retrofit2.HttpException
import java.lang.Exception

class AccountRepositoryImpl internal constructor(private val accountService: AccountService,
                            private val cache: EasyKardexCache): AccountRepository {

    override suspend fun login(username: String, password: String) : Result<User> = try {

            val result = accountService.login(LoginRequest(username, password))

            if(result.isSuccessful && result.body() != null){

                val body = result.body()!!

                cache.userLoggedIn = body.user
                cache.token = body.token
                cache.role = body.user.roleId

                Result.Success(body.user.mapToDomain())
            } else {
                Result.Failure(FailureReason.INTERNAL_ERROR)
            }

        } catch(httpEx: HttpException) {
            httpEx.printStackTrace()

            if(httpEx.code() == 404){
                Result.Failure(FailureReason.INVALID_CREDENTIALS)
            } else {
                Result.Failure(FailureReason.INTERNAL_ERROR)
            }
        } catch(ex: Exception) {
            ex.printStackTrace()
            Result.Failure(FailureReason.INTERNAL_ERROR)
        }

    override suspend fun logout(): Result<Boolean> = try {
            val result = accountService.logout()

            if(result.isSuccessful) {
                cache.userLoggedIn = null
                cache.token = null
                cache.role = null
            }

            Result.Success(result.isSuccessful)
        } catch(ex: Exception) {
            ex.printStackTrace()
            Result.Failure(FailureReason.INTERNAL_ERROR)
        }
}