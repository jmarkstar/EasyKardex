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
 * Created by jmarkstar on 7/12/19 6:01 PM
 *
 */

package com.jmarkstar.easykardex.data.entities

import com.jmarkstar.easykardex.domain.models.User
import com.jmarkstar.easykardex.domain.models.UserRole
import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class UserEntity(@Json(name = "idu") val userId: Long,
                      @Json(name = "idr") var roleId: UserRoleEntity,
                      @Json(name = "un") var username: String,
                      @Json(name = "fn") var fullname: String)

fun UserEntity.mapToDomain(): User {

    val role = if (roleId == UserRoleEntity.ADMIN) UserRole.ADMIN else UserRole.OPERATOR
    return User(userId, role, username, fullname )
}

/*
@JsonClass(generateAdapter = true)
data class UserJson(@Json(name = "idu") val userId: Long,
                    @Json(name = "idr") var roleId: Int,
                    @Json(name = "un") var username: String,
                    @Json(name = "fn") var fullname: String)

class UserAdapter {

    @ToJson fun toJson(user: UserEntity): UserJson {
        return UserJson(user.userId, user.roleId.id, user.username, user.fullname)
    }

    @FromJson fun fromJson(json: UserJson): UserEntity {
        Log.v("UserAdapter","json: $json")
        return UserEntity(json.userId, UserRoleEntity.getRoleByID(json.roleId)!!, json.username, json.fullname)
    }
}*/