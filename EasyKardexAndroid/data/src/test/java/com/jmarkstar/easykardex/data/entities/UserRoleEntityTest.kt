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
 * Created by jmarkstar on 7/28/19 11:26 AM
 *
 */

package com.jmarkstar.easykardex.data.entities

import com.jmarkstar.easykardex.data.di.constantTestModule
import com.jmarkstar.easykardex.data.di.networkModule
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.koin.core.context.startKoin
import org.koin.core.context.stopKoin

class UserRoleEntityTest {

    @Before
    fun setupKoinModules() {

        startKoin {
            modules(listOf(constantTestModule, networkModule))
        }
    }

    @Test
    fun `get Admin Role by Id success`() {

        val admin = UserRoleEntity.getRoleByID(1)
        Assert.assertTrue(admin == UserRoleEntity.ADMIN)
    }

    @Test
    fun `get Operator Role by Id success`() {

        val operator = UserRoleEntity.getRoleByID(2)
        Assert.assertTrue(operator == UserRoleEntity.OPERATOR)
    }

    @Test
    fun `get Null By Role Id success`() {

        val unknownId = UserRoleEntity.getRoleByID(3)
        Assert.assertNull(unknownId)
    }

    @After
    fun stopKoinModules(){
        stopKoin()
    }
}