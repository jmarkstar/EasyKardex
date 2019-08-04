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
 * Created by jmarkstar on 8/5/19 12:38 AM
 *
 */

package com.jmarkstar.easykardex.data.api

import androidx.test.core.app.ApplicationProvider
import com.jmarkstar.easykardex.data.di.cacheModule
import com.jmarkstar.easykardex.data.di.commonModule
import com.jmarkstar.easykardex.data.di.constantTestModule
import com.jmarkstar.easykardex.data.di.networkModule
import org.junit.After
import org.junit.Before
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.startKoin
import org.koin.core.context.stopKoin
import org.koin.test.KoinTest

abstract class BaseApiTest: KoinTest {

    @Before
    fun setupKoinModules(){
        println("setupKoinModules")
        startKoin {
            androidContext(ApplicationProvider.getApplicationContext())
            modules(listOf(commonModule, constantTestModule, networkModule, cacheModule))
        }
    }

    @After
    fun stopKoinModules(){
        println("stopKoinModules")
        stopKoin()
    }
}