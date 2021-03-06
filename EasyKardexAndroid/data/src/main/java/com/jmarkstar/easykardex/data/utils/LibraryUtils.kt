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
 * Created by jmarkstar on 7/13/19 7:36 AM
 *
 */

package com.jmarkstar.easykardex.data.utils

import org.threeten.bp.format.DateTimeFormatter
import java.text.SimpleDateFormat
import java.util.*

internal object LibraryUtils {

    val localDatetimeFormat = "yyyy-MM-dd HH:mm:ss"
    val dateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

    val localDateTimeFormater = DateTimeFormatter.ofPattern(localDatetimeFormat)
    val zonedDateTimeFormatter = DateTimeFormatter.ofPattern(dateTimeFormat)
    val dateTimeFormatter = SimpleDateFormat(dateTimeFormat, Locale.getDefault())

    val dateFormmatter = SimpleDateFormat("yyyy-mm-dd", Locale.getDefault())
}