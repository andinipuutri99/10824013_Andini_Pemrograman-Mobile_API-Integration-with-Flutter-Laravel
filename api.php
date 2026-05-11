<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\MahasiswaController;

Route::apiResource('mahasiswa', MahasiswaController::class);