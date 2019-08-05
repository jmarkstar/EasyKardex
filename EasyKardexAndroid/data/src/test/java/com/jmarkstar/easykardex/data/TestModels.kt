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
 * Created by jmarkstar on 7/28/19 7:28 PM
 *
 */

package com.jmarkstar.easykardex.data

import com.jmarkstar.easykardex.data.entities.*
import org.threeten.bp.LocalDateTime

// Data for Login

val rightUserName = "jmarkstar"
val rightPassword = "abc123"
val wrongUserName = "myuser"
val wrongPassword = "abcdef"
val wrongToken = "asasasadfdfdf1212113"

val creationDate = LocalDateTime.now()
val lastUpdateDate = LocalDateTime.now()

val userEntity = UserEntity(1L, UserRoleEntity.ADMIN, "username1","full name", creationDate, lastUpdateDate, EntityStatus.ACTIVE)

val brand = BrandEntity(null, "Coca cola", creationDate, lastUpdateDate, EntityStatus.ACTIVE)
val category = CategoryEntity(1L, "Groseries", lastUpdateDate, EntityStatus.ACTIVE)
val unit = UnitEntity(1L, "Liter", lastUpdateDate, EntityStatus.ACTIVE)
val provider = ProviderEntity(1L, "Google AU","Paul Smith","+610432654030")

val brands = Array(10){ brand }