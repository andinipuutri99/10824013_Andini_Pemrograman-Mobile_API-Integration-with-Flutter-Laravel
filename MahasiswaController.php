<?php

namespace App\Http\Controllers;

use App\Models\Mahasiswa;
use Illuminate\Http\Request;
use OpenApi\Attributes as OA;

#[OA\Info(
    version: "1.0.0",
    title: "API Mahasiswa",
    description: "Dokumentasi API Mahasiswa Laravel"
)]
class MahasiswaController extends Controller
{
    #[OA\Get(
        path: "/api/mahasiswa",
        summary: "Ambil semua data mahasiswa",
        tags: ["Mahasiswa"],
        responses: [
            new OA\Response(
                response: 200,
                description: "Berhasil mengambil data mahasiswa"
            )
        ]
    )]
    public function index()
    {
        return Mahasiswa::all();
    }

    #[OA\Post(
        path: "/api/mahasiswa",
        summary: "Tambah data mahasiswa",
        tags: ["Mahasiswa"],
        requestBody: new OA\RequestBody(
            required: true,
            content: new OA\JsonContent(
                required: ["nama", "nim", "jurusan"],
                properties: [
                    new OA\Property(property: "nama", type: "string", example: "Andin"),
                    new OA\Property(property: "nim", type: "string", example: "10824013"),
                    new OA\Property(property: "jurusan", type: "string", example: "Teknik Komputer")
                ]
            )
        ),
        responses: [
            new OA\Response(
                response: 201,
                description: "Data berhasil ditambahkan"
            )
        ]
    )]
    public function store(Request $request)
    {
        return Mahasiswa::create($request->all());
    }

    #[OA\Put(
        path: "/api/mahasiswa/{id}",
        summary: "Update data mahasiswa",
        tags: ["Mahasiswa"],
        parameters: [
            new OA\Parameter(
                name: "id",
                in: "path",
                required: true,
                description: "ID Mahasiswa",
                schema: new OA\Schema(type: "integer")
            )
        ],
        requestBody: new OA\RequestBody(
            required: true,
            content: new OA\JsonContent(
                properties: [
                    new OA\Property(property: "nama", type: "string", example: "Andini"),
                    new OA\Property(property: "nim", type: "string", example: "10824013"),
                    new OA\Property(property: "jurusan", type: "string", example: "Teknik Informatika")
                ]
            )
        ),
        responses: [
            new OA\Response(
                response: 200,
                description: "Data berhasil diupdate"
            )
        ]
    )]
    public function update(Request $request, string $id)
    {
        $mahasiswa = Mahasiswa::findOrFail($id);

        $mahasiswa->update($request->all());

        return $mahasiswa;
    }

    #[OA\Delete(
        path: "/api/mahasiswa/{id}",
        summary: "Hapus data mahasiswa",
        tags: ["Mahasiswa"],
        parameters: [
            new OA\Parameter(
                name: "id",
                in: "path",
                required: true,
                description: "ID Mahasiswa",
                schema: new OA\Schema(type: "integer")
            )
        ],
        responses: [
            new OA\Response(
                response: 200,
                description: "Data berhasil dihapus"
            )
        ]
    )]
    public function destroy(string $id)
    {
        $mahasiswa = Mahasiswa::findOrFail($id);

        $mahasiswa->delete();

        return response()->json([
            "message" => "Data berhasil dihapus"
        ]);
    }
}