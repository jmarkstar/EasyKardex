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
 * Created by jmarkstar on 7/13/19 6:56 AM
 *
 */

package com.jmarkstar.easykardex.data.cache

import android.content.Context
import android.content.SharedPreferences
import com.jmarkstar.easykardex.data.entities.UserEntity
import com.jmarkstar.easykardex.data.entities.UserRoleEntity
import com.jmarkstar.easykardex.data.utils.LibraryConstants
import com.squareup.moshi.Moshi

internal class EasyKardexCache(private val context: Context, private val moshi: Moshi) {

    private val TOKEN = "token"
    private val USER_ROLE = "role"
    private val USER_LOGGED_IN = "user_logged_in"
    private val BRANDS_LAST_UPDATE_DATE = "brands_last_update_date"
    private val CATEGORIES_LAST_UPDATE_DATE = "categories_last_update_date"
    private val UNITS_LAST_UPDATE_DATE = "units_last_update_date"
    private val PRODUCTS_LAST_UPDATE_DATE = "products_last_update_date"
    private val PROVIDERS_LAST_UPDATE_DATE = "providers_last_update_date"

    private val sharedPreferences: SharedPreferences by lazy {
        context.getSharedPreferences("easykardex", Context.MODE_PRIVATE)
    }

    var token: String?
        get() = sharedPreferences.getString(TOKEN, LibraryConstants.EMPTY)
        set(value){
            if(value != null){
                sharedPreferences.edit().putString(TOKEN, value).apply()
            } else {
                sharedPreferences.edit().remove(TOKEN).apply()
            }
        }

    var role: UserRoleEntity?
        get() {
            val roleId = sharedPreferences.getInt(USER_ROLE, 0)
            return UserRoleEntity.getRoleByID(roleId)
        }
        set(value){
            if(value != null){
                sharedPreferences.edit().putInt(USER_ROLE, value.id).apply()
            } else {
                sharedPreferences.edit().remove(USER_ROLE).apply()
            }
        }

    var userLoggedIn: UserEntity?
        get() {

            val userJson = sharedPreferences.getString(USER_LOGGED_IN, LibraryConstants.EMPTY)
            return if ( userJson == null || userJson == LibraryConstants.EMPTY){
                null
            } else {
                val jsonAdapter = moshi.adapter(UserEntity::class.java)
                jsonAdapter.fromJson(userJson)
            }
        }
        set(value) {

            if(value != null){
                val jsonAdapter = moshi.adapter(UserEntity::class.java)
                val userJson = jsonAdapter.toJson(value)

                sharedPreferences.edit().putString(USER_LOGGED_IN, userJson).apply()
            } else {
                sharedPreferences.edit().remove(USER_LOGGED_IN).apply()
            }
        }

    var brandsLastUpdateDate: String?
        get() {
            val lastUpdate = sharedPreferences.getString(BRANDS_LAST_UPDATE_DATE, LibraryConstants.EMPTY)
            return if ( lastUpdate == null || lastUpdate == LibraryConstants.EMPTY) {
                null
            } else {
                lastUpdate
            }
        }
        set(value) {
            sharedPreferences.edit().putString(BRANDS_LAST_UPDATE_DATE, value).apply()
        }

    var categoriesLastUpdateDate: String?
        get() {
            val lastUpdate = sharedPreferences.getString(CATEGORIES_LAST_UPDATE_DATE, LibraryConstants.EMPTY)
            return if ( lastUpdate == null || lastUpdate == LibraryConstants.EMPTY) {
                null
            } else {
                lastUpdate
            }
        }
        set(value) {
            sharedPreferences.edit().putString(CATEGORIES_LAST_UPDATE_DATE, value).apply()
        }

    var unitsLastUpdateDate: String?
        get() {
            val lastUpdate = sharedPreferences.getString(UNITS_LAST_UPDATE_DATE, LibraryConstants.EMPTY)
            return if ( lastUpdate == null || lastUpdate == LibraryConstants.EMPTY) {
                null
            } else {
                lastUpdate
            }
        }
        set(value) {
            sharedPreferences.edit().putString(UNITS_LAST_UPDATE_DATE, value).apply()
        }

    var productsLastUpdateDate: String?
        get() {
            val lastUpdate = sharedPreferences.getString(PRODUCTS_LAST_UPDATE_DATE, LibraryConstants.EMPTY)
            return if ( lastUpdate == null || lastUpdate == LibraryConstants.EMPTY) {
                null
            } else {
                lastUpdate
            }
        }
        set(value) {
            sharedPreferences.edit().putString(PRODUCTS_LAST_UPDATE_DATE, value).apply()
        }

    var providersLastUpdateDate: String?
        get() {
            val lastUpdate = sharedPreferences.getString(PROVIDERS_LAST_UPDATE_DATE, LibraryConstants.EMPTY)
            return if ( lastUpdate == null || lastUpdate == LibraryConstants.EMPTY) {
                null
            } else {
                lastUpdate
            }
        }
        set(value) {
            sharedPreferences.edit().putString(PROVIDERS_LAST_UPDATE_DATE, value).apply()
        }

    fun clear(){
        sharedPreferences.edit().clear().apply()
    }
}