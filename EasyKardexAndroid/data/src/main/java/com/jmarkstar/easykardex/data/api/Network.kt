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
 * Created by jmarkstar on 7/24/19 2:59 PM
 *
 */

package com.jmarkstar.easykardex.data.api

import com.jmarkstar.easykardex.domain.models.FailureReason
import com.jmarkstar.easykardex.domain.models.Result
import java.lang.Exception
import java.net.UnknownHostException

suspend fun <T: Any>processNetworkResult(resultCode: Int, sucessResult: suspend () -> Result<T>): Result<T> {
    return when(resultCode){
        in 200..204 -> {

            sucessResult.invoke()
        }
        401 -> Result.Failure(FailureReason.EXPIRED_TOKEN)
        403 -> Result.Failure(FailureReason.WRONG_VALUES_ON_PARAMETERS)
        else -> Result.Failure(FailureReason.INTERNAL_ERROR)
    }
}

fun <T: Any>processError(exception: Exception): Result<T> {
    exception.printStackTrace()
    return when(exception){
        is UnknownHostException -> Result.Failure(FailureReason.SERVER_COULDNT_BE_FOUND)
        else -> Result.Failure(FailureReason.INTERNAL_ERROR)
    }
}