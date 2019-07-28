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
 * Created by jmarkstar on 7/28/19 7:12 PM
 *
 */

package com.jmarkstar.easykardex.data.cache

import android.os.Build
import androidx.test.core.app.ApplicationProvider
import com.jmarkstar.easykardex.data.di.cacheModule
import com.jmarkstar.easykardex.data.di.commonModule
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.startKoin
import org.koin.core.context.stopKoin
import org.koin.test.KoinTest
import org.koin.test.inject
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [Build.VERSION_CODES.O_MR1])
class EasyKardexCacheTest: KoinTest {

    private val cache: EasyKardexCache  by inject()

    @Before
    fun setup() {

        startKoin {
            androidContext(ApplicationProvider.getApplicationContext())
            modules(listOf(commonModule, cacheModule))
        }
    }

    @Test
    fun `store session token success`() {
        cache.token = "asa5sas54544as5a5saa"
        assert(cache.token == "asa5sas54544as5a5saa")
    }

    @Test
    fun `delete session token success`() {
        cache.token = null
        Assert.assertNull(cache.token)
    }

    @After
    fun unsetup() {
        stopKoin()
    }
}