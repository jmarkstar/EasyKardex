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

import android.util.Log
import com.jmarkstar.easykardex.data.api.AccountService
import com.jmarkstar.easykardex.data.api.request.LoginRequest
import com.jmarkstar.easykardex.data.api.response.LoginResponse
import com.jmarkstar.easykardex.data.cache.EasyKardexCache
import com.jmarkstar.easykardex.data.models.User
import com.jmarkstar.easykardex.data.models.UserRole
import retrofit2.Response
import java.lang.Exception

class AccountRepository {

    private lateinit var accountService: AccountService
    private lateinit var cache: EasyKardexCache

    suspend fun login(username: String, password: String) : Pair<String, User>? {

        val result : Response<LoginResponse>?

        try {
            result = accountService.login(LoginRequest(username, password))
        } catch(ex: Exception) {
            Log.e("AccountRepository","Error login")
            return null
        }

        if(result.isSuccessful){

            val body = checkNotNull(result.body()){
                return null
            }

            return  Pair(body.token, body.user)
        } else {
            return null
        }
    }

    suspend fun logout(): Boolean {

        val result : Response<Void>?

        return try {
            result = accountService.logout()
            result.isSuccessful
        } catch(ex: Exception) {
            Log.e("AccountRepository","Error logout")
            false
        }
    }

    fun saveUserLoggedIn(user: User){
        cache.userLoggedIn = user
    }

    fun saveSessionToken(token: String){
        cache.token = token
    }

    fun saveUserRole(userRole: UserRole){
        cache.role = userRole
    }

    fun deleteSessionInfo(){
        cache.userLoggedIn = null
        cache.token = null
        cache.role = null
    }
}