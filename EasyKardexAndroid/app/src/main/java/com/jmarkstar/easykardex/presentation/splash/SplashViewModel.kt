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
 * Created by jmarkstar on 7/22/19 12:28 PM
 *
 */

package com.jmarkstar.easykardex.presentation.splash

import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.jmarkstar.easykardex.domain.models.Result
import com.jmarkstar.easykardex.domain.usecases.GetUserLoggedInUseCase
import com.jmarkstar.easykardex.extensions.setLoading
import com.jmarkstar.easykardex.models.Resource
import com.jmarkstar.easykardex.models.UserItem
import com.jmarkstar.easykardex.models.mapToPresentation
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class SplashViewModel constructor(private val getUserLoggedInUseCase: GetUserLoggedInUseCase): ViewModel() {

    var userLoggedId = MutableLiveData<Resource<UserItem>>()

    fun getUserLoggedIn() {
        viewModelScope.launch {

            //userLoggedId.setLoading()

            val loginResult = withContext(Dispatchers.Default) {

                when( val result = getUserLoggedInUseCase.getUser()) {

                    is Result.Success -> {
                        Log.v("viewmodel","sucess")
                        Resource.Success(result.value.mapToPresentation())
                    }
                    is Result.Failure -> {
                        Log.v("viewmodel","Failure")
                        Resource.Error(result.reason)
                    }
                }
            }

            userLoggedId.value = loginResult
        }
    }
}