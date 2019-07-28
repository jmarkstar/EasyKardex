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
 * Created by jmarkstar on 7/27/19 10:54 PM
 *
 */

package com.jmarkstar.easykardex.data.entities

import com.jmarkstar.easykardex.data.di.constantTestModule
import com.jmarkstar.easykardex.data.di.networkModule
import com.jmarkstar.easykardex.data.utils.readFileAsString
import com.squareup.moshi.Moshi
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.koin.core.context.startKoin
import org.koin.core.context.stopKoin
import org.koin.test.KoinTest
import org.koin.test.inject
import org.threeten.bp.LocalDateTime

class UserEntityTest : KoinTest {

    private val moshi: Moshi by inject()

    val creationDate = LocalDateTime.now()
    val lastUpdateDate = LocalDateTime.now()

    val userEntity = UserEntity(1L, UserRoleEntity.ADMIN, "username1","full name", creationDate, lastUpdateDate, EntityStatus.ACTIVE)

    @Before
    fun setupKoinModules() {

        startKoin {
            modules(listOf(constantTestModule, networkModule))
        }
    }

    @Test
    fun `parse json to user entity success`() {
        val userLoggedIn = readFileAsString(this@UserEntityTest.javaClass, "assets/UserLoggedInUser.json")
        val userAdapter = moshi.adapter(UserEntity::class.java)
        val userResponseJson = userAdapter.fromJson(userLoggedIn)

        Assert.assertNotNull(userResponseJson)
    }

    @Test
    fun `parse user entity to json success`() {
        val userAdapter = moshi.adapter(UserEntity::class.java)
        val jsonString = userAdapter.toJson(userEntity)

        Assert.assertNotNull(jsonString)
        Assert.assertEquals(true, jsonString != "")
    }

    @Test
    fun `map entity to domain success`() {

        val user = userEntity.mapToDomain()

        Assert.assertNotNull(userEntity)

        Assert.assertTrue(user.userId == userEntity.userId)
        Assert.assertTrue(user.roleId.value == userEntity.roleId.id)
        Assert.assertTrue(user.username == userEntity.username)
        Assert.assertTrue(user.fullname == userEntity.fullname)
    }

    @After
    fun stopKoinModules(){
        stopKoin()
    }
}