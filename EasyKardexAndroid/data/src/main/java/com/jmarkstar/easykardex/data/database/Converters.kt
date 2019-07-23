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
 * Created by jmarkstar on 7/19/19 12:35 AM
 *
 */

package com.jmarkstar.easykardex.data.database

import androidx.room.TypeConverter
import com.jmarkstar.easykardex.data.entities.EntityStatus
import com.jmarkstar.easykardex.data.utils.LibraryUtils
import org.threeten.bp.OffsetDateTime
import java.util.*

class Converters {

    companion object {

        //DATE TIME

        @TypeConverter
        @JvmStatic
        fun toOffsetDateTime(value: String?): OffsetDateTime? {
            return value?.let {
                return LibraryUtils.offsetDateTimeFormatter.parse(it, OffsetDateTime::from)
            }
        }

        @TypeConverter
        @JvmStatic
        fun fromOffsetDateTime(date: OffsetDateTime?): String? {
            return date?.format(LibraryUtils.offsetDateTimeFormatter)
        }

        // DATE

        @TypeConverter
        @JvmStatic
        fun toDate(timestamp: Long?): Date? {
            return when (timestamp) {
                null -> null
                else -> Date(timestamp)
            }
        }

        @TypeConverter
        @JvmStatic
        fun toMillis(date: Date?): Long? {
            return date?.time
        }

        // STATUS

        @TypeConverter
        @JvmStatic
        fun toStatus(status: EntityStatus?): Int? {
            return status?.value
        }

        @TypeConverter
        @JvmStatic
        fun toEntityStatus(status: Int?): EntityStatus? {
            return if (status == 1) EntityStatus.ACTIVE else EntityStatus.INACTIVE
        }
    }
}